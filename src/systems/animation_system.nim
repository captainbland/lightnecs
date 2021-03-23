import system
import sets
import sdl2
import glm
import sugar
import print
import times

import sys_sugar
import ../components/draw_rect_component
import ../components/position_component
import ../asset_management/sprite_manager

import ../ecslib/ecs
import ../ecslib/optionsutils

type
    AnimationSystem* = ref object of MySystem

proc calcSourceRect(frame: Frame): sdl2.Rect =
    var sdl_rect = sdl2.rect(cint(frame.sheet_x),
         cint(frame.sheet_y),
         cint(frame.frame_width),
         cint(frame.frame_height))

    return sdl_rect

proc calcDestRect(pos: AbsolutePositionComponent, frame: Frame): sdl2.Rect =
    var sdl_rect = sdl2.rect(cint(pos.pos.x),
         cint(pos.pos.y),
         cint(frame.frame_width*2),
         cint(frame.frame_height*2))

    return sdl_rect

proc run*(self: AnimationSystem, my_world: World, renderer: RendererPtr) =
    #echo "trying to run printing system"
    
    proc update_and_draw(sprite: Sprite, anim: AnimationInfo,  pos: AbsolutePositionComponent) =
        renderer.setDrawColor 255, 255, 255, 255 # white
        let dt = getTime() - anim.last_frame_at 
        if(dt > initDuration(anim.frames[anim.current_frame].duration*1000*1000)):
            anim.current_frame = (anim.current_frame + 1) mod anim.frames.len
            anim.last_frame_at = getTime()

        var src_rect = calcSourceRect(anim.frames[anim.current_frame])
        var dest_rect = calcDestRect(pos, anim.frames[anim.current_frame])


        renderer.copy sprite.texture, addr src_rect, addr dest_rect


    for entity in self.entities:
        applyWithAll(query(Sprite),
                     query(AnimationInfo),
                     query(AbsolutePositionComponent),
                     update_and_draw)
        .orElse(() => echo "could draw sprite :(")