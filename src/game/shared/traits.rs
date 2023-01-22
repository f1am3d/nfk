use sdl2;
use sdl2::render::Texture;

pub trait NewRenderLayer {
    fn getTexture() -> Texture {
        return Texture::new(
            &texture_creator,
            sdl2::pixels::PixelFormatEnum::RGBA8888,
            sdl2::render::TextureAccess::Static,
            character_image.query().width,
            character_image.query().height,
        ).unwrap();
    }
}
