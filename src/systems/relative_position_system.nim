import system
import sets
import options
import glm
import sugar

import sys_sugar

import ../ecslib/ecs
import ../ecslib/optionsutils

import ../components/position_component
import ../ecslib/parent_component

type
    RelativePositionSystem* = ref object of MySystem



proc run*(self: RelativePositionSystem, my_world: World, dt: float) = 
    proc compute(rel_pos: RelativePositionComponent, abs_pos: AbsolutePositionComponent, parent: ParentComponent) = 
        let parent_position = queryRelated(AbsolutePositionComponent, parent.entity)
                             .get(AbsolutePositionComponent(pos:vec2i(0,0)))
        abs_pos.pos = parent_position.pos + rel_pos.pos


    for entity in self.entities:
        applyWithAll(query(RelativePositionComponent),
                    query(AbsolutePositionComponent),
                    query(ParentComponent),
                    compute)          
        .orElse(() => echo "problem in relative position system")


