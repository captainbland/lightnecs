type
    Component* = ref object of RootObj
        component_type*: string
        
    ComponentType* = string

    NotImplementedException* = object of Exception

template generate_typeinfo*(my_type: untyped, my_typename: string): untyped =
    method typename*(x: my_type): ComponentType = 
        return my_typename.ComponentType

method typename*(x: Component): ComponentType = 
    raise newException(NotImplementedException, "NotImplemented")

