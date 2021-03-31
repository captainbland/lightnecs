import sys_sugar
import ../components/physics_components
import ../ecslib/ecs
import ../chipmunk/chipmunk

type
    PhysicsSystem* = ref object of MySystem

method onAddEntity*(self: PhysicsSystem, entity: Entity): void = 
    var shape_component = getComponent[PhysicsShapeComponent](self.world, entity)
    var body_component = getComponent[PhysicsBodyComponent](self.world, entity)
    let space = getComponent[SpaceComponent](self.world, self.world.globalEntity).space

    case shape_component.shapeType:
        of Rectangle:
            let moment = MomentForBox(1.0, shape_component.width, shape_component.height)
            let body = newBody(1.0, moment)
            let shape = newBoxShape(body, BB(l:0, b:0, r:shape_component.width, t:shape_component.height))

            body_component.body = space.addBody(body)
            shape_component.chipmunkShape = space.addShape(shape)
            


proc run(self: PhysicsSystem, dt: float) =
    space.run