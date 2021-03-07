import sdl2
import os
import ecslib/world
import ecslib/component
import components/draw_rect_component
import components/position_component
import components/player_input_component
import systems/draw_rect_system
import systems/player_input_system

discard sdl2.init(INIT_EVERYTHING)

var
  window: WindowPtr
  render: RendererPtr

var my_world: World = getWorld()
echo my_world.am_world

let draw_rect_sys = my_world.registerSystem(DrawRectSystem())
let input_sys = my_world.registerSystem(PlayerInputSystem())


my_world.setSystemSignature(draw_rect_sys,
   newSignature(getComponentType[DrawRectComponent](my_world),
                getComponentType[PositionComponent](my_world)))

my_world.setSystemSignature(input_sys,
  newSignature(getComponentType[PositionComponent](my_world),
  getComponentType[PlayerInputComponent](my_world)))

let my_entity = my_world.createEntity()
my_world.addComponent(my_entity, DrawRectComponent(width:50, height:50))
my_world.addComponent(my_entity, PositionComponent(x: 10, y: 10))
my_world.addComponent(my_entity, PlayerInputComponent())

let my_entity2 = my_world.createEntity()
my_world.addComponent(my_entity2, DrawRectComponent(width:50, height:50))
my_world.addComponent(my_entity2, PositionComponent(x: 70, y: 10))


let my_entity3 = my_world.createEntity()
my_world.addComponent(my_entity3, DrawRectComponent(width:50, height:50))
my_world.addComponent(my_entity3, PositionComponent(x: 130, y: 10))

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

