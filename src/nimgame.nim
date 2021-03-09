import sdl2
import os
import chipmunk
import ecslib/world
import ecslib/component
import components/draw_rect_component
import components/position_component
import components/player_input_component
import systems/draw_rect_system
import systems/player_input_system
import ecslib/builders
import ecslib/entity

discard sdl2.init(INIT_EVERYTHING)

var
    window: WindowPtr
    render: RendererPtr

var space = chipmunk.newSpace()

var my_world: World = getWorld()
echo my_world.am_world




# let draw_rect_sys = newSystemBuilder(my_world, DrawRectSystem())
#     .needsComponent(DrawRectComponent())
#     .needsComponent(PositionComponent())
#     .done()

let draw_rect_sys = createSystem(my_world, DrawRectSystem(), DrawRectComponent(), PositionComponent())

let input_sys = createSystem(my_world, PlayerInputSystem(), PositionComponent(), PlayerInputComponent())


# discard newEntityBuilder(my_world)
#   .withComponent(DrawRectComponent(width:50, height:50))
#   .withComponent(PositionComponent(x: 10, y: 10))
#   .withComponent(PlayerInputComponent())
#   .done()
createEntity(my_world, DrawRectComponent(width: 50, height: 50), PositionComponent(x:10, y: 10), PlayerInputComponent())

createEntity(my_world, DrawRectComponent(width:50, height:50), PositionComponent(x: 70, y: 10))

createEntity(my_world, DrawRectComponent(width:50, height:50), PositionComponent(x: 130, y: 10))

window = createWindow("ECSy game", 100, 100, 640,480, SDL_WINDOW_SHOWN)
render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)


var
    evt = sdl2.defaultEvent
    runGame = true

while runGame:
    while pollEvent(evt):
        if evt.kind == QuitEvent:
            runGame = false
            break
        else:
            input_sys.on_poll(my_world, addr evt)
    
    sleep(33)
    input_sys.on_update(my_world, 1.0)
    render.setDrawColor 0,0,0,255
    render.clear
    draw_rect_sys.run(my_world, render)
    render.present

destroy render
destroy window

