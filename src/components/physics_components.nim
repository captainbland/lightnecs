import ../chipmunk/chipmunk

type
    PhysicsBody* = ref object of RootObj
        body*: BodyPtr
    
    ShapeType* = enum 
        Rectangle

    PhysicsShape* = ref object of RootObj
        chipmunkShape*: ShapePtr
        case shapeType: ShapeType
            of Rectangle:
                width*: float
                height*: float
    

# proc loadPhysicsBody(space: SpacePtr, mass=5.0): PhysicsBody =
#     space.addBody(chipmunk.newBody(mass))
    