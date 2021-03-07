type
    Input* {.pure.} = enum
        Up,
        Down,
        Left,
        Right
        None

    PlayerInputComponent* = ref object of RootObj # marker component
        inputs*: array[Input, bool]