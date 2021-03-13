import system
import hashes
import sets
import sdl2
import options
import glm

import ../ecslib/ecs

import ../components/player_input_component
import ../components/position_component
import ../components/parent_component

type
    RelativePositionSystem* = ref object of MySystem



proc run*(self: RelativePositionSystem, my_world: World, dt: float) = 
    for entity in self.entities:
        let relative_position = getComponent[RelativePositionComponent](my_world, entity)
        let parent = getComponent[ParentComponent](my_world, entity)

        let parent_position = maybeGetComponent[AbsolutePositionComponent](my_world, parent.entity).get(AbsolutePositionComponent(pos:vec2i(0,0)))
        var absolute_position = getComponent[AbsolutePositionComponent](my_world, entity)


        absolute_position.pos = parent_position.pos + relative_position.pos
