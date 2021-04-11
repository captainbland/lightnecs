import ../components/physics_components
import ../components/position_component
import ../components/jump_state

import ../ecslib/ecs
import ../chipmunk/chipmunk
import glm
import times
import sets
import print

type
    JumpingSystem* = ref object of MySystem
        # force the garbage collector to recognise jump collision datas are attached to the jumping system
        # need to re-evaluate this for removal of entities
        jumping_datas: seq[JumpCollisionData] 
    JumpCollisionData* = ref object of RootObj
        entity: Entity
        system: JumpingSystem


proc beginProcessCollision(arb: ArbiterPtr, space: SpacePtr, collisionData: pointer): bool {.cdecl.} =
    var jump_collision_data: JumpCollisionData = cast[ptr JumpCollisionData](collisionData)[]
    var world = jump_collision_data.system.world
    var entity = jump_collision_data.entity
    setComponent[JumpStateComponent](world, entity, JumpStateComponent(jump_state: GROUNDED))

    return true
    

method onAddEntity(self: JumpingSystem, entity: Entity): void =
    var space = getComponent[SpaceComponent](self.world, self.world.globalEntity).space
    var shape = getComponent[PhysicsShapeComponent](self.world, entity).chipmunkShape
    var collision_data = JumpCollisionData(entity: entity, system: self)
    self.jumping_datas.add(collision_data)
    space.addCollisionHandler(shape.getCollisionType(),
        GROUND_COLLISION,
        begin=beginProcessCollision,
        data=cast[pointer](addr self.jumping_datas[len(self.jumping_datas)-1]))

proc updateJump(self: JumpingSystem, entity: Entity): void =
    var physics_body_component = getComponent[PhysicsBodyComponent](self.world, entity)
    var physics_body = physics_body_component.body
    var jump_state_component = getComponent[JumpStateComponent](self.world, entity)
    var jump_signal = jump_state_component.jump_signal 
    if jump_signal == JUMP:
        var jump_state = jump_state_component.jump_state
        
        if jump_state == GROUNDED:
            physics_body.setVel(vec2d(physics_body.getVel.x,-100))
            # changing object branch, must create new jump state

            var new_jump_state = JumpStateComponent(
                jump_state: ON_AIR,
                jump_started: getTime()
            )
            setComponent[JumpStateComponent](self.world, entity, new_jump_state)
        

        elif jump_state == ON_AIR:
            if getTime() - jump_state_component.jump_started < initDuration(milliseconds=250):
                physics_body.setVel(vec2d(physics_body.getVel.x,-100))


        jump_state_component.jump_signal = NONE    


proc run*(self: JumpingSystem): void =
    for entity in self.entities:
        updateJump(self, entity)