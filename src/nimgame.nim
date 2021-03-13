import sdl2
import os
import chipmunk
import ecslib/ecs
import components/[draw_rect_component, position_component, player_input_component, parent_component]
import systems/[draw_rect_system, player_input_system, relative_position_system]
import glm

discard sdl2.init(INIT_EVERYTHING)

var
    window: WindowPtr
    render: RendererPtr

var space = chipmunk.newSpace()

var my_world: World = getWorld()
echo my_world.am_world
# systems
let draw_rect_sys = createSystem(my_world, DrawRectSystem(), DrawRectComponent(), AbsolutePositionComponent())
let input_sys = createSystem(my_world, PlayerInputSystem(), RelativePositionComponent(), PlayerInputComponent())
let relative_position_sys = createSystem(my_world, RelativePositionSystem(), RelativePositionComponent(), AbsolutePositionComponent(), ParentComponent())

#entities
let root_entity = createEntity(my_world, AbsolutePositionComponent(pos:vec2i(0,0)))

let player_entity = createEntity(my_world,
 DrawRectComponent(width: 50, height: 50),
 AbsolutePositionComponent(), 
 RelativePositionComponent(pos:vec2i(10,10)), 
 PlayerInputComponent(),
 ParentComponent(entity:root_entity))

let player_entity_2 = createEntity(my_world,
 DrawRectComponent(width: 50, height: 50),
 AbsolutePositionComponent(), 
 RelativePositionComponent(pos:vec2i(100,10)), 
 PlayerInputComponent(),
 ParentComponent(entity:player_entity))

createEntity(my_world,
 DrawRectComponent(width:50, height:50), 
 AbsolutePositionComponent(), 
 RelativePositionComponent(pos:vec2i(70,10)),
 PlayerInputComponent(),
 ParentComponent(entity: player_entity_2))

let destroyed_entity = createEntity(my_world,
 DrawRectComponent(width:50, height:50), 
 AbsolutePositionComponent(), 
 RelativePositionComponent(pos:vec2i(50,50)),
 ParentComponent(entity: player_entity))



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
    relative_position_sys.run(my_world, 1.0)
    render.setDrawColor 0,0,0,255
    render.clear
    draw_rect_sys.run(my_world, render)
    render.present

destroy render
destroy window
echo my_world.serialise()
