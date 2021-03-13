import glm

type AbsolutePositionComponent* = ref object of RootObj
    pos*: Vec2i

type RelativePositionComponent* = ref object of RootObj
    pos*: Vec2i