

import options 
export options

type OrElser* = object
    exec: bool

proc orElse*(elser: OrElser, to_apply: proc()): bool {.discardable.} =
    if elser.exec: to_apply()
    return elser.exec

proc fine(): OrElser = OrElser(exec:false)
proc problem(): OrElser = OrElser(exec:true)


proc applyWith*[T](my_opt: Option[T], to_apply: proc(x: T)): OrElser =
    if(my_opt.isSome()):
        to_apply(my_opt.get())
        return fine()
    else:
        return problem()

proc applyWithAll*[T1, T2](my_opt1: Option[T1], my_opt2: Option[T2], to_apply: proc(x1: T1, x2: T2)): OrElser =
    if(my_opt1.isSome() and my_opt2.isSome()):
        to_apply(my_opt1.get(), my_opt2.get())
        return fine()
    else:
        return problem()

proc applyWithAll*[T1, T2, T3](my_opt1: Option[T1], my_opt2: Option[T2], my_opt3: Option[T3], to_apply: proc(x1: T1, x2: T2, x3: T3)): OrElser =
    if(my_opt1.isSome() and my_opt2.isSome() and my_opt3.isSome()):
        to_apply(my_opt1.get(), my_opt2.get(), my_opt3.get())
        return fine()
    else:
        return problem()