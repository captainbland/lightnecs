import ../chipmunk/chipmunk

type
    PhysicsBody = ref object of RootObj
        body: BodyPtr

proc loadPhysicsBody(space: SpacePtr, mass=5.0): PhysicsBody =
    space.addBody(chipmunk.newBody(mass))
    