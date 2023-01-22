use std::{
  ffi::CString,
  thread,
  thread::Thread,
  time
};
use std::time::Duration;
use sdl2::{
  event::Event,
  EventPump,
  keyboard::Keycode,
  pixels::Color,
  render::WindowCanvas,
  Sdl,
  video::{
    GLProfile,
    Window
  },
  VideoSubsystem
};
use crate::game::constants;

pub struct RendererLayer {
  pub event_pump: EventPump,
  canvas: WindowCanvas,
  context: Sdl,
  video_subsystem: VideoSubsystem
}
impl RendererLayer {
  pub fn construct() -> Self {
    let context = Self::sdl_init();
    let video_subsystem = Self::sdl_video_subsystem_init(&context);
    let event_pump = Self::get_event_pump(&context);
    let window = Self::sdl_init_window(&video_subsystem);
    let mut canvas = Self::sdl_init_canvas(window);

    canvas.set_draw_color(Color::RGB(0, 255, 255));
    canvas.clear();
    canvas.present();

    Self::init_gl_attributes(&video_subsystem);

    return Self {
      canvas,
      context,
      event_pump,
      video_subsystem
    };
  }

  fn sdl_init() -> Sdl {
    return sdl2::init()
      .expect("SDL initialization failed");
  }

  fn sdl_video_subsystem_init(context: &Sdl) -> VideoSubsystem {
    return context
      .video()
      .expect("Video subsystem initialization failed");
  }

  fn sdl_init_window(video_subsystem: &VideoSubsystem) -> Window {
    return video_subsystem
      .window(
        "Need For Kill 2",
        constants::WIDTH,
        constants::HEIGHT,
      )
      .position_centered()
      .opengl()
      .build()
      .expect("Video subsystem build failed");
  }

  fn sdl_init_canvas(window: Window) -> WindowCanvas {
    return window
      .into_canvas()
      .build()
      .unwrap()
  }

  fn init_gl_attributes(video_subsystem: &VideoSubsystem) {
    let gl_attr = video_subsystem.gl_attr();

    gl_attr.set_context_profile(GLProfile::Core);
    gl_attr.set_context_version(3, 3);

    debug_assert_eq!(gl_attr.context_profile(), GLProfile::Core);
    debug_assert_eq!(gl_attr.context_version(), (3, 3));
  }

  fn get_event_pump(context: &Sdl) -> EventPump {
    return context
      .event_pump()
      .expect("Event Pump init failed");
  }

  pub fn render_frame(self: &mut Self) {
    self.canvas.set_draw_color(Color::RGB(0, 64, 255));
    self.canvas.clear();
  }

  pub fn listen_events(self: &mut Self) -> bool {
    let pump = &mut self.event_pump;

    for event in pump.poll_iter() {
      match event {
        Event::Quit { .. } | Event::KeyDown { keycode: Some(Keycode::Escape), .. } => {
          return true;
        }
        _ => {}
      }
    }

    return false;
  }

  pub fn add_rendering_layer(canvas: &WindowCanvas) {
    let texture_creator = canvas.texture_creator();

    // texture_creator.create_texture().unwrap()
  }

  pub fn start(self: &mut Self) {
    // Starting renderer in main thread
    loop {
      let caught = self.listen_events();

      if caught {
        break;
      }

      // perf_stats::FPS_STATS.get_fps();

      self.render_frame();

      thread::sleep(
        Duration::new(
          0,
          1_000_000_000_u32 / 60,
        )
      );
    }
  }
}
