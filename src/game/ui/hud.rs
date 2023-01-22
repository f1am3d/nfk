use sdl2::pixels::PixelFormatEnum;
use sdl2::render::{Texture, SurfaceCanvas};
use crate::game::shared::traits;



pub struct GameHud {
    perf_stats: crate::engine::ui::stats::UiPerfStats
}
impl GameHud {
    pub fn new() -> GameHud {
        GameHud {
            perf_stats: stats::UiPerfStats {}
        }
    }
}
impl traits::NewRenderLayer for GameHud {
    fn getTexture() -> Texture {
        let surface = SurfaceCanvas::new(512, 512, PixelFormatEnum::RGB24).unwrap();

        return Texture::new(
            &texture_creator,
            sdl2::pixels::PixelFormatEnum::RGBA8888,
            sdl2::render::TextureAccess::Static,
            character_image.query().width,
            character_image.query().height,
        ).unwrap();
    }
}