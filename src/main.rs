extern crate sdl2;
extern crate gl;

use std::{thread, time};
use std::ffi::c_void;
use sdl2::event::Event;
use sdl2::keyboard::Keycode;
use sdl2::video::GLProfile;
use defaults::{
    WIDTH,
    HEIGHT
};

mod defaults;

fn main() {
    let sdl_context = sdl2::init().unwrap();
    let video_subsystem = sdl_context.video().unwrap();
    let gl_attr = video_subsystem.gl_attr();

    gl_attr.set_context_profile(GLProfile::Core);
    gl_attr.set_context_version(3, 3);

    let window =
        video_subsystem.window("Need For Kill 2", WIDTH, HEIGHT)
            .opengl()
            .build()
            .unwrap();

    // Unlike the other example above, nobody created a context for your window, so you need to create one.
    let ctx =
        window
            .gl_create_context()
            .unwrap();

    let loader = |name: &str| -> *const c_void {
        video_subsystem.gl_get_proc_address(name) as *const c_void
    };

    gl::load_with(loader);

    debug_assert_eq!(gl_attr.context_profile(), GLProfile::Core);
    debug_assert_eq!(gl_attr.context_version(), (3, 3));

    let mut event_pump = sdl_context.event_pump().unwrap();

    'running: loop {
        unsafe {
            gl::ClearColor(0.6, 0.0, 0.8, 1.0);
            gl::Clear(gl::COLOR_BUFFER_BIT);
        }

        window.gl_swap_window();

        for event in event_pump.poll_iter() {
            match event {
                Event::Quit { .. } | Event::KeyDown { keycode: Some(Keycode::Escape), .. } => {
                    break 'running;
                }
                _ => {}
            }
        }

        thread::sleep(
            time::Duration::new(
                0,
                1_000_000_000u32 / 60,
            )
        );
    }

    // renderer::create_context();
    // renderer::initRenderer();
}
