import system
import sets
import sdl2
import glm
import sugar

import ../components/draw_rect_component
import ../components/position_component

import ../ecslib/ecs
import ../ecslib/optionsutils

type
    DrawRectSystem* = ref object of MySystem


proc run*(self: DrawRectSystem, my_world: World, renderer: RendererPtr) =
    #echo "trying to run printing system"
    
    proc draw(rect: DrawRectComponent, pos: AbsolutePositionComponent) =
        renderer.setDrawColor 255, 255, 255, 255 # white
        var r = rect(
            cint(pos.pos.x), cint(pos.pos.y),
            cint(rect.width), cint(rect.height)
        )
        renderer.fillRect r

    for entity in self.entities:
        applyWithAll(queryComponent[DrawRectComponent](my_world, entity),
                     queryComponent[AbsolutePositionComponent](my_world, entity),
                     draw)
        .orElse(() => echo "could not draw rect, a component is missing :(")

        
            
