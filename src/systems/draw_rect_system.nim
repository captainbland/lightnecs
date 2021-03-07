import system
import hashes
import sets
import sdl2

import ../components/draw_rect_component
import ../ecslib/my_system
import ../ecslib/world
import ../ecslib/typeutil
type
    DrawRectSystem* = ref object of MySystem

proc draw(renderer: RendererPtr, rect: DrawRectComponent) =
  renderer.setDrawColor 255, 255, 255, 255 # white
  var r = rect(
    cint(rect.x), cint(rect.y),
    cint(rect.width), cint(rect.height)
  )
  renderer.fillRect(r)

proc type_hash*(c: DrawRectSystem): Hash = hash($DRAW_RECT_SYSTEM)

proc run*(self: DrawRectSystem, my_world: World, window: RendererPtr) =
    #echo "trying to run printing system"
    
    for entity in self.entities:
        let rect = getComponent[DrawRectComponent](my_world, entity)

        rect.x += 2
        echo "drawing rect having entity"
        draw(window, rect)
        
            
