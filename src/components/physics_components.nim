import ../chipmunk/chipmunk

type
    PhysicsBodyComponent* = ref object of RootObj
        body*: BodyPtr
        space*: SpacePtr
    
    ShapeType* = enum 
        Rectangle

    PhysicsShapeComponent* = ref object of RootObj
        chipmunkShape*: ShapePtr
        case shapeType*: ShapeType
            of Rectangle:
                width*: float
                height*: float
    

# proc loadPhysicsBody(space: SpacePtr, mass=5.0): PhysicsBody =
#     space.addBody(chipmunk.newBody(mass))
    