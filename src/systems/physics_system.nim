import sys_sugar
import ../components/physics_components
import ../components/position_component
import ../ecslib/ecs
import ../chipmunk/chipmunk
import sets
import glm

type
    PhysicsSystem* = ref object of MySystem

method onAddEntity*(self: PhysicsSystem, entity: Entity): void = 
    echo "on add entity for physics system working ok"
    var shape_component = getComponent[PhysicsShapeComponent](self.world, entity)
    var body_component = getComponent[PhysicsBodyComponent](self.world, entity)
    let space = getComponent[SpaceComponent](self.world, self.world.globalEntity).space

    case shape_component.shapeType:
        of Rectangle:
            let moment = MomentForBox(1.0, shape_component.width, shape_component.height)
            let body = newBody(1.0, moment)
            let shape = newBoxShape(body, shape_component.width, shape_component.height)
            body_component.body = space.addBody(body)
            shape_component.chipmunkShape = space.addShape(shape)
            


proc run*(self: PhysicsSystem) =
    var timeStep = 1.0/30.0

    let space_component = getComponent[SpaceComponent](self.world, self.world.globalEntity)
    space_component.space.step(timeStep)

    for entity in self.entities:
        let body = getComponent[PhysicsBodyComponent](self.world, entity).body
        echo "body pos: ", body.getPos
        let pos = getComponent[RelativePositionComponent](self.world, entity)
        pos.pos = vec2i(body.getPos)
