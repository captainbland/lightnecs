import system
import hashes
import sets
import sdl2
import options

import ../ecslib/my_system
import ../ecslib/world

import ../components/player_input_component
import ../components/position_component
import ../components/parent_component

type
    RelativePositionSystem* = ref object of MySystem



proc run*(self: RelativePositionSystem, my_world: World, dt: float) = 
    for entity in self.entities:
        let relative_position = getComponent[RelativePositionComponent](my_world, entity)
        let parent = getComponent[ParentComponent](my_world, entity)

        let parent_position = maybeGetComponent[AbsolutePositionComponent](my_world, parent.entity).get(AbsolutePositionComponent(x:0,y:0))
        var absolute_position = getComponent[AbsolutePositionComponent](my_world, entity)


        absolute_position.x = relative_position.x + parent_position.x
        absolute_position.y = relative_position.y + parent_position.y
