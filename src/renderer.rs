use std::ffi::{CStr, CString};
use std::num::NonZeroU32;
use std::ops::Deref;

use winit::event::{Event, WindowEvent};
use winit::event_loop::EventLoopBuilder;
use winit::window::{Window, WindowBuilder};

use raw_window_handle::HasRawWindowHandle;

use glutin::config::{Config, ConfigTemplateBuilder};
use glutin::context::{ContextApi, ContextAttributesBuilder};
use glutin::display::GetGlDisplay;
use glutin::prelude::*;
use glutin::surface::{Surface, SurfaceAttributesBuilder, SwapInterval, WindowSurface};

use glutin_winit::{self, DisplayBuilder};

pub mod gl {
    #![allow(clippy::all)]
    include!(concat!(env!("OUT_DIR"), "/gl_bindings.rs"));

    pub use Gles2 as Gl;
}

pub fn create_context() {
    let event_loop = glium::glutin::event_loop::EventLoopBuilder::new().build();

    // Only windows requires the window to be present before creating the display.
    // Other platforms don't really need one.
    //
    // XXX if you don't care about running on android or so you can safely remove
    // this condition and always pass the window builder.
    let window_builder =
        if cfg!(wgl_backend) {
            let builder = glium::glutin::window::WindowBuilder::new()
                .with_transparent(true);

            Some(builder)
        } else {
            None
        };

    // The template will match only the configurations supporting rendering to
    // windows.
    let template = glutin::config::ConfigTemplateBuilder::new().with_alpha_size(8).with_transparency(true);

    let display_builder = DisplayBuilder::new().with_window_builder(window_builder);

    let (mut window, gl_config) = display_builder
        .build(&event_loop, template, |configs| {
            // Find the config with the maximum number of samples, so our triangle will
            // be smooth.
            configs
                .reduce(|accum, config| {
                    let transparency_check = config.supports_transparency().unwrap_or(false)
                        & !accum.supports_transparency().unwrap_or(false);

                    if transparency_check || config.num_samples() > accum.num_samples() {
                        config
                    } else {
                        accum
                    }
                })
                .unwrap()
        })
        .unwrap();

    println!("Picked a config with {} samples", gl_config.num_samples());

    let raw_window_handle = window.as_ref().map(|window| window.raw_window_handle());

    // XXX The display could be obtained from the any object created by it, so we
    // can query it from the config.
    let gl_display = gl_config.display();

    // The context creation part. It can be created before surface and that's how
    // it's expected in multithreaded + multiwindow operation mode, since you
    // can send NotCurrentContext, but not Surface.
    let context_attributes = glutin::context::ContextAttributesBuilder::new().build(raw_window_handle);

    // Since glutin by default tries to create OpenGL core context, which may not be
    // present we should try gles.
    let fallback_context_attributes = glutin::context::ContextAttributesBuilder::new()
        .with_context_api(glutin::context::ContextApi::Gles(None))
        .build(raw_window_handle);
    let mut not_current_gl_context = Some(unsafe {
        gl_display.create_context(&gl_config, &context_attributes).unwrap_or_else(|_| {
            gl_display
                .create_context(&gl_config, &fallback_context_attributes)
                .expect("failed to create context")
        })
    });

    let mut state = None;
    let mut renderer = None;
    event_loop.run(move |event, window_target, control_flow| {
        control_flow.set_wait();
        match event {
            Event::Resumed => {
                #[cfg(target_os = "android")]
                println!("Android window available");

                let window = window.take().unwrap_or_else(|| {
                    let window_builder = glium::glutin::window::WindowBuilder::new().with_transparent(true);
                    glutin_winit::finalize_window(window_target, window_builder, &gl_config)
                        .unwrap()
                });

                let gl_window = GlWindow::new(window, &gl_config);

                // Make it current.
                let gl_context = not_current_gl_context
                    .take()
                    .unwrap()
                    .make_current(&gl_window.surface)
                    .unwrap();

                // The context needs to be current for the Renderer to set up shaders and
                // buffers. It also performs function loading, which needs a current context on
                // WGL.
                renderer.get_or_insert_with(|| Renderer::new(&gl_display));

                // Try setting vsync.
                if let Err(res) = gl_window
                    .surface
                    .set_swap_interval(&gl_context, glutin::surface::SwapInterval::Wait(NonZeroU32::new(1).unwrap()))
                {
                    eprintln!("Error setting vsync: {:?}", res);
                }

                assert!(state.replace((gl_context, gl_window)).is_none());
            }
            Event::Suspended => {
                // This event is only raised on Android, where the backing NativeWindow for a GL
                // Surface can appear and disappear at any moment.
                println!("Android window removed");

                // Destroy the GL Surface and un-current the GL Context before ndk-glue releases
                // the window back to the system.
                let (gl_context, _) = state.take().unwrap();
                assert!(not_current_gl_context
                    .replace(gl_context.make_not_current().unwrap())
                    .is_none());
            }
            Event::WindowEvent { event, .. } => match event {
                WindowEvent::Resized(size) => {
                    if size.width != 0 && size.height != 0 {
                        // Some platforms like EGL require resizing GL surface to update the size
                        // Notable platforms here are Wayland and macOS, other don't require it
                        // and the function is no-op, but it's wise to resize it for portability
                        // reasons.
                        if let Some((gl_context, gl_window)) = &state {
                            gl_window.surface.resize(
                                gl_context,
                                NonZeroU32::new(size.width).unwrap(),
                                NonZeroU32::new(size.height).unwrap(),
                            );
                            let renderer = renderer.as_ref().unwrap();
                            renderer.resize(size.width as i32, size.height as i32);
                        }
                    }
                }
                WindowEvent::CloseRequested => {
                    control_flow.set_exit();
                }
                _ => (),
            },
            Event::RedrawEventsCleared => {
                if let Some((gl_context, gl_window)) = &state {
                    let renderer = renderer.as_ref().unwrap();
                    renderer.draw();
                    gl_window.window.request_redraw();

                    gl_window.surface.swap_buffers(gl_context).unwrap();
                }
            }
            _ => (),
        }
    })
}

fn handle_window_event(window: &mut glfw::Window, event: glfw::WindowEvent) {
    match event {
        glfw::WindowEvent::Key(Key::Escape, _, Action::Press, _) => {
            window.set_should_close(true)
        }
        _ => {}
    }
}

pub fn initRenderer() {
    let library = vulkano::VulkanLibrary::new().unwrap();

    let instance = vulkano::instance::Instance::new(
        library,
        vulkano::instance::InstanceCreateInfo {
            enabled_extensions: required_extensions,
            // Enable enumerating devices that use non-conformant vulkan implementations. (ex. MoltenVK)
            enumerate_portability: true,
            ..Default::default()
        },
    ).unwrap();
}


pub struct GlWindow {
    // XXX the surface must be dropped before the window.
    pub surface: Surface<WindowSurface>,

    pub window: Window,
}

impl GlWindow {
    pub fn new(window: Window, config: &Config) -> Self {
        let (width, height): (u32, u32) = window.inner_size().into();
        let raw_window_handle = window.raw_window_handle();
        let attrs = SurfaceAttributesBuilder::<WindowSurface>::new().build(
            raw_window_handle,
            NonZeroU32::new(width).unwrap(),
            NonZeroU32::new(height).unwrap(),
        );

        let surface = unsafe { config.display().create_window_surface(config, &attrs).unwrap() };

        Self { window, surface }
    }
}

pub struct Renderer {
    program: gl::types::GLuint,
    vao: gl::types::GLuint,
    vbo: gl::types::GLuint,
    gl: gl::Gl,
}

impl Renderer {
    pub fn new<D: GlDisplay>(gl_display: &D) -> Self {
        unsafe {
            let gl = gl::Gl::load_with(|symbol| {
                let symbol = CString::new(symbol).unwrap();
                gl_display.get_proc_address(symbol.as_c_str()).cast()
            });

            if let Some(renderer) = get_gl_string(&gl, gl::RENDERER) {
                println!("Running on {}", renderer.to_string_lossy());
            }
            if let Some(version) = get_gl_string(&gl, gl::VERSION) {
                println!("OpenGL Version {}", version.to_string_lossy());
            }

            if let Some(shaders_version) = get_gl_string(&gl, gl::SHADING_LANGUAGE_VERSION) {
                println!("Shaders version on {}", shaders_version.to_string_lossy());
            }

            let vertex_shader = create_shader(&gl, gl::VERTEX_SHADER, VERTEX_SHADER_SOURCE);
            let fragment_shader = create_shader(&gl, gl::FRAGMENT_SHADER, FRAGMENT_SHADER_SOURCE);

            let program = gl.CreateProgram();

            gl.AttachShader(program, vertex_shader);
            gl.AttachShader(program, fragment_shader);

            gl.LinkProgram(program);

            gl.UseProgram(program);

            gl.DeleteShader(vertex_shader);
            gl.DeleteShader(fragment_shader);

            let mut vao = std::mem::zeroed();
            gl.GenVertexArrays(1, &mut vao);
            gl.BindVertexArray(vao);

            let mut vbo = std::mem::zeroed();
            gl.GenBuffers(1, &mut vbo);
            gl.BindBuffer(gl::ARRAY_BUFFER, vbo);
            gl.BufferData(
                gl::ARRAY_BUFFER,
                (VERTEX_DATA.len() * std::mem::size_of::<f32>()) as gl::types::GLsizeiptr,
                VERTEX_DATA.as_ptr() as *const _,
                gl::STATIC_DRAW,
            );

            let pos_attrib = gl.GetAttribLocation(program, b"position\0".as_ptr() as *const _);
            let color_attrib = gl.GetAttribLocation(program, b"color\0".as_ptr() as *const _);
            gl.VertexAttribPointer(
                pos_attrib as gl::types::GLuint,
                2,
                gl::FLOAT,
                0,
                5 * std::mem::size_of::<f32>() as gl::types::GLsizei,
                std::ptr::null(),
            );
            gl.VertexAttribPointer(
                color_attrib as gl::types::GLuint,
                3,
                gl::FLOAT,
                0,
                5 * std::mem::size_of::<f32>() as gl::types::GLsizei,
                (2 * std::mem::size_of::<f32>()) as *const () as *const _,
            );
            gl.EnableVertexAttribArray(pos_attrib as gl::types::GLuint);
            gl.EnableVertexAttribArray(color_attrib as gl::types::GLuint);

            Self { program, vao, vbo, gl }
        }
    }

    pub fn draw(&self) {
        unsafe {
            self.gl.UseProgram(self.program);

            self.gl.BindVertexArray(self.vao);
            self.gl.BindBuffer(gl::ARRAY_BUFFER, self.vbo);

            self.gl.ClearColor(0.1, 0.1, 0.1, 0.9);
            self.gl.Clear(gl::COLOR_BUFFER_BIT);
            self.gl.DrawArrays(gl::TRIANGLES, 0, 3);
        }
    }

    pub fn resize(&self, width: i32, height: i32) {
        unsafe {
            self.gl.Viewport(0, 0, width, height);
        }
    }
}

impl Deref for Renderer {
    type Target = gl::Gl;

    fn deref(&self) -> &Self::Target {
        &self.gl
    }
}

impl Drop for Renderer {
    fn drop(&mut self) {
        unsafe {
            self.gl.DeleteProgram(self.program);
            self.gl.DeleteBuffers(1, &self.vbo);
            self.gl.DeleteVertexArrays(1, &self.vao);
        }
    }
}

unsafe fn create_shader(
    gl: &gl::Gl,
    shader: gl::types::GLenum,
    source: &[u8],
) -> gl::types::GLuint {
    let shader = gl.CreateShader(shader);
    gl.ShaderSource(shader, 1, [source.as_ptr().cast()].as_ptr(), std::ptr::null());
    gl.CompileShader(shader);
    shader
}

fn get_gl_string(gl: &gl::Gl, variant: gl::types::GLenum) -> Option<&'static CStr> {
    unsafe {
        let s = gl.GetString(variant);
        (!s.is_null()).then(|| CStr::from_ptr(s.cast()))
    }
}