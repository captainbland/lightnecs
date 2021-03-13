import system
import sets
import sdl2
import glm
import sugar

import sys_sugar
import ../components/draw_rect_component
import ../components/position_component
import ../asset_management/sprite_manager

import ../ecslib/ecs
import ../ecslib/optionsutils

type
    AnimationSystem* = ref object of MySystem

proc calcSourceRect(frame: Frame): ptr sdl2.Rect =
    var sdl_rect = sdl2.rect(cint(frame.sheet_x),
         cint(frame.sheet_y),
         cint(frame.frame_width),
         cint(frame.frame_height))

    return addr sdl_rect



proc run*(self: AnimationSystem, my_world: World, renderer: RendererPtr) =
    #echo "trying to run printing system"
    
    proc draw(sprite: Sprite, anim: AnimationInfo,  pos: AbsolutePositionComponent) =
        renderer.setDrawColor 255, 255, 255, 255 # white
        renderer.copy sprite.texture, calcSourceRect(anim.frames[0]), nil


    for entity in self.entities:
        applyWithAll(query(Sprite),
                     query(AnimationInfo),
                     query(AbsolutePositionComponent),
                     draw)
        .orElse(() => echo "could draw sprite :(")