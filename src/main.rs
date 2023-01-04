extern crate sdl2;
extern crate gl;

mod constants;
mod renderer;

fn main() {
    let renderer::RendererInitResult {
        event_pump: mut pump,
        window_canvas: mut canvas
    } = renderer::init();

    loop {
        let status = renderer::check_events(&mut pump);

        if status {
            renderer::render_frame(&mut canvas);
        }
        else {
            break;
        }
    }

    renderer::thread_delay();

    // renderer::create_context();
    // renderer::init_renderer();
}
