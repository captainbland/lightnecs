import sdl2
import os
import ecslib/world
import ecslib/component
import components/draw_rect_component
import systems/draw_rect_system

discard sdl2.init(INIT_EVERYTHING)

var
  window: WindowPtr
  render: RendererPtr

var my_world: World = getWorld()
echo my_world.am_world

let draw_rect_sys = my_world.registerSystem(DrawRectSystem())
my_world.setSystemSignature(draw_rect_sys, newSignature(getComponentType[DrawRectComponent](my_world)))

let my_entity = my_world.createEntity()
my_world.addComponent(my_entity, DrawRectComponent(x:10, y:10, width:50, height:50))

let my_entity2 = my_world.createEntity()
my_world.addComponent(my_entity2, DrawRectComponent(x:100, y:10, width:50, height:50))


let my_entity3 = my_world.createEntity()
my_world.addComponent(my_entity3, DrawRectComponent(x:200, y:30, width:50, height:50))

window = createWindow("SDL Skeleton", 100, 100, 640,480, SDL_WINDOW_SHOWN)
render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)




var
  evt = sdl2.defaultEvent
  runGame = true

while runGame:
  while pollEvent(evt):
    if evt.kind == QuitEvent:
      runGame = false
      break
  sleep(16)
  render.setDrawColor 0,0,0,255
  render.clear
  draw_rect_sys.run(my_world, render)
  render.present

destroy render
destroy window

