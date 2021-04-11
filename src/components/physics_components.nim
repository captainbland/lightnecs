import ../chipmunk/chipmunk

type
    PhysicsBodyComponent* = ref object of RootObj
        body*: BodyPtr
    
    ShapeType* = enum 
        Rectangle, Circle

    PhysicsShapeComponent* = ref object of RootObj
        chipmunkShape*: ShapePtr
        case shapeType*: ShapeType
            of Rectangle:
                width*: float
                height*: float
            of Circle:
                diameter*: float
    
    SpaceComponent* = ref object of RootObj
        space*: SpacePtr

# collision types:

const PLAYER_COLLISION*: CollisionType = 1
const GROUND_COLLISION*: CollisionType = 2 

# proc loadPhysicsBody(space: SpacePtr, mass=5.0): PhysicsBody =
#     space.addBody(chipmunk.newBody(mass))
