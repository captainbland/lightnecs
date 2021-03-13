import system
import sets
import options
import glm
import sugar

import ../ecslib/ecs
import ../ecslib/optionsutils

import ../components/player_input_component
import ../components/position_component
import ../components/parent_component

type
    RelativePositionSystem* = ref object of MySystem



proc run*(self: RelativePositionSystem, my_world: World, dt: float) = 
    proc compute(rel_pos: RelativePositionComponent, abs_pos: AbsolutePositionComponent, parent: ParentComponent) = 
        let parent_position = queryComponent[AbsolutePositionComponent](my_world, parent.entity).get(AbsolutePositionComponent(pos:vec2i(0,0)))
        abs_pos.pos = parent_position.pos + rel_pos.pos


    for entity in self.entities:
        applyWithAll(queryComponent[RelativePositionComponent](my_world, entity),
                    queryComponent[AbsolutePositionComponent](my_world, entity),
                    queryComponent[ParentComponent](my_world, entity),
                    compute)          
        .orElse(() => echo "problem in relative position system")


