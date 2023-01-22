pub mod shared;
pub mod ui;
pub mod constants;
pub mod state;
pub mod renderer;

use std::thread;
use std::thread::JoinHandle;
use std::time::Duration;
use state::{State};
use crate::game::renderer::RendererLayer;

struct Threads {
  audio: JoinHandle<()>,
}

pub struct EngineConstructParams {
  // audio: AudioLayer
}

pub struct Engine {
  state: State,
  threads: Threads,
}
impl Engine {
  pub fn construct(params: &EngineConstructParams) -> Self {
    let state = State::construct();
    let threads = Self::init_threads(&params);

    return Self {
      state,
      threads,
    }
  }

  fn init_threads(params: &EngineConstructParams) -> Threads {
    let audio = Self::init_audio_thread();

    return Threads {
      audio
    }
  }

  fn init_audio_thread() -> JoinHandle<()> {
    thread::spawn(move || {})
  }
}
