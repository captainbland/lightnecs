import times

type 
    JumpState* = enum
        GROUNDED, ON_AIR
    

    JumpSignal* = enum
        NONE, JUMP

    JumpStateComponent* = ref object of RootObj
        case jump_state*: JumpState
            of ON_AIR:
                jump_started*: Time
            of GROUNDED: discard

        jump_signal*: JumpSignal

