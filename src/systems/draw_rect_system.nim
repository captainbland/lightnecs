import system
import hashes
import sets
import sdl2
import glm

import ../components/draw_rect_component
import ../components/position_component

import ../ecslib/ecs

type
    DrawRectSystem* = ref object of MySystem


proc draw(renderer: RendererPtr, pos: Vec2i, rect: DrawRectComponent) =
  renderer.setDrawColor 255, 255, 255, 255 # white
  var r = rect(
    cint(pos.x), cint(pos.y),
    cint(rect.width), cint(rect.height)
  )
  renderer.fillRect(r)

proc run*(self: DrawRectSystem, my_world: World, window: RendererPtr) =
    #echo "trying to run printing system"
    
    for entity in self.entities:
        let rect = getComponent[DrawRectComponent](my_world, entity)
        let pos = getComponent[AbsolutePositionComponent](my_world, entity).pos

        echo "drawing rect having entity"
        draw(window, pos, rect)
        
            
