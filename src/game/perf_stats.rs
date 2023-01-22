struct PerfStats {
     fps: i32
}
impl PerfStats {
    pub const fn new() -> PerfStats {
        PerfStats {
            fps: 0
        }
    }

    pub fn get_fps(&mut self) -> u32 {
        self.fps = 123;

        return 123;
    }
}

pub const FPS_STATS: PerfStats = PerfStats::new();
