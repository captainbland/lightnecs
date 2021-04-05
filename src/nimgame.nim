import sdl2
import os
import chipmunk/chipmunk
import ecslib/ecs
import ecslib/[parent_component, children_component]
import components/[draw_rect_component, position_component, player_input_component, physics_components]
import systems/[draw_rect_system, player_input_system, relative_position_system, animation_system, physics_system]
import asset_management/sprite_manager
import glm

import asset_management/sprite_manager
import os
discard sdl2.init(INIT_EVERYTHING)

var
    window: WindowPtr
    render: RendererPtr
let meter = (32.0)/1.61
var space = chipmunk.newSpace()
space.gravity = vec2d(0,9.8*meter)
var my_world: World = getWorld()
echo my_world.am_world


# systems
let draw_rect_sys = createSystem(my_world, DrawRectSystem(), DrawRectComponent(), AbsolutePositionComponent())
let input_sys = createSystem(my_world, PlayerInputSystem(), RelativePositionComponent(), PlayerInputComponent())
let relative_position_sys = createSystem(my_world, RelativePositionSystem(), RelativePositionComponent(), AbsolutePositionComponent(), ParentComponent())
let animation_sys = createSystem(my_world, AnimationSystem(), AbsolutePositionComponent(), Sprite(), AnimationInfo())
let physics_sys = createSystem(my_world, PhysicsSystem(name: "physics"), RelativePositionComponent(), PhysicsBodyComponent(), PhysicsShapeComponent())


#SDL setup
window = createWindow("ECSy game", 100, 100, 640,480, SDL_WINDOW_SHOWN)
render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)

# assets
var my_sprite_manager = newSpriteManager("assets/sprites", render)
let (flaremage_sprite, flaremage_anim) = my_sprite_manager.loadSpritesheet("flaremage-stand-left")

#entities
my_world.addComponent(my_world.globalEntity, SpaceComponent(space: space))

let root_entity = createEntity(my_world, AbsolutePositionComponent(pos:vec2i(0,0)))

let player_entity = createEntity(my_world,
 flaremage_sprite,
 flaremage_anim,
 AbsolutePositionComponent(), 
 RelativePositionComponent(pos:vec2i(10,10)), 
 PlayerInputComponent(),
 ParentComponent(entity:root_entity),
 PhysicsBodyComponent(),
 PhysicsShapeComponent(shapeType: physics_components.ShapeType.Rectangle, width:26, height:32))

# # uncomment for entity spam fun
# for x in 0..100:
#     for y in 0..91: 
#         var to_add = 20 + x*4
#         var y = 20 + y * 4
#         var pos = vec2i(vec2(to_add, y))

#         createEntity(my_world,
#             flaremage_sprite,
#             flaremage_anim,
#             AbsolutePositionComponent(), 
#             RelativePositionComponent(pos:pos), 
#             PlayerInputComponent(),
#             ParentComponent(entity:root_entity))

let player_entity_2 = createEntity(my_world,
 DrawRectComponent(width: 50, height: 50),
 AbsolutePositionComponent(), 
 RelativePositionComponent(pos:vec2i(100,10)), 
 PlayerInputComponent())

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
    physics_sys.run()
    input_sys.on_update(my_world, 1.0)
    relative_position_sys.run(my_world, 1.0)
    render.setDrawColor 0,0,0,255
    render.clear
    draw_rect_sys.run(my_world, render)
    animation_sys.run(my_world, render)
    render.present

destroy render
destroy window
chipmunk.free space
echo my_world.serialise()
