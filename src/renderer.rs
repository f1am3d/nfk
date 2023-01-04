use std::{thread, time};
use std::ffi::{CStr, CString, c_void};

use sdl2::event::Event;
use sdl2::EventPump;
use sdl2::keyboard::Keycode;
use sdl2::pixels::Color;
use sdl2::render::WindowCanvas;
use sdl2::video::GLProfile;

use crate::constants;

pub struct RendererInitResult {
    pub event_pump: EventPump,
    pub window_canvas: WindowCanvas
}

pub fn init() -> RendererInitResult {
    let sdl_context = sdl2::init().unwrap();
    let video_subsystem = sdl_context.video().unwrap();
    let window = video_subsystem
        .window(
            "Need For Kill 2",
            constants::WIDTH,
            constants::HEIGHT,
        )
        .opengl()
        .build()
        .unwrap();


    let mut sdl_canvas = window
        .into_canvas()
        .build()
        .unwrap();

    sdl_canvas.set_draw_color(Color::RGB(0, 255, 255));
    sdl_canvas.clear();
    sdl_canvas.present();

    let gl_attr = video_subsystem.gl_attr();

    gl_attr.set_context_profile(GLProfile::Core);
    gl_attr.set_context_version(3, 3);

    debug_assert_eq!(gl_attr.context_profile(), GLProfile::Core);
    debug_assert_eq!(gl_attr.context_version(), (3, 3));

    return RendererInitResult {
        event_pump: sdl_context.event_pump().unwrap(),
        window_canvas: sdl_canvas
    };
}

pub fn render_frame(canvas: &mut WindowCanvas) {
    canvas.set_draw_color(Color::RGB(0, 64, 255));
    canvas.clear();
    canvas.present();
}

pub fn check_events(event_pump: &mut EventPump) -> bool {
    for event in event_pump.poll_iter() {
        match event {
            Event::Quit { .. }
            | Event::KeyDown { keycode: Some(Keycode::Escape), .. } => {
                return false;
            }
            _ => {}
        }
    }

    return true;
}

pub fn thread_delay() {
    thread::sleep(
        time::Duration::new(
            0,
            1_000_000_000u32 / 60,
        )
    );
}