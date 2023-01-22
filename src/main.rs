extern crate sdl2;
extern crate gl;

mod game;

use game::{
    Engine,
};
use crate::game::EngineConstructParams;
use crate::game::renderer::RendererLayer;


fn main() {
    let mut renderer_layer = RendererLayer::construct();
    renderer_layer.start();

    let engine_params = EngineConstructParams {};
    let engine = Engine::construct(&engine_params);

    // let hud = GameHud::new();

    // hud.getRenderingLayer();
   

}
