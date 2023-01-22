pub struct State {
  gravity: f32,
  phys_fps: i32,
}
impl State {
  pub fn construct() -> Self {
    return Self {
      gravity: 1.0,
      phys_fps: 30
    }
  }
}
