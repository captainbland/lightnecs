type
    MyType[T] = object
        val: T

proc newMyType[T](v: T): MyType[T] = MyType[T](val: v)


proc getMyType[T](): MyType[T] =
    var my_obj {.global.} = MyType[T]()
    my_obj


proc getTypeGetter(my_val: string): proc():MyType =
    var my_obj  = newMyType(my_val)
    proc getter(): MyType = 
        my_obj
    return getter

getMyType()[string].val = "hi"
echo getMyType[string]().val
echo getTypeGetter("custom")().val
echo getTypeGetter("different")().val