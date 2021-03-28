import sys_sugar
import ../components/physics_components
import ../ecslib/ecs
import ../chipmunk/chipmunk

type
    PhysicsSystem* = ref object of MySystem

method onAddEntity*(self: PhysicsSystem, entity: Entity): void = 
    var shape_component = getComponent[PhysicsShapeComponent](self.world, entity)
    var body_component = getComponent[PhysicsBodyComponent](self.world, entity)
    let space = body_component.space

    case shape_component.shapeType:
        of Rectangle:
            let moment = MomentForBox(1.0, shape_component.width, shape_component.height)
            let body = newBody(1.0, moment)
            space.addBody(body)
            space.addShape()
            #newBoxShape(body, BB(0, ))


proc run(self: PhysicsSystem, dt float) =
    discards