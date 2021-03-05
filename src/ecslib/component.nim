import re
import hashes

type
    Component* = object
        component_type*: string
        
    ComponentType* = Hash

    NotImplementedException* = object of Exception


# proc camel_to_const_case(my_string: string): string  {.compileTime.} =
#     my_string.replace(re"([a-z])([A-Z])", "?_?")  

proc print_typename(typename: string): void {.compileTime.} =
    echo "here's the thing: ", typename

template generate_typeinfo*(my_type: untyped, component_type: ComponentType): untyped =
    method typename*(x: my_type): ComponentType = 
        return component_type



method typename*(x: Component): ComponentType = 
    raise newException(NotImplementedException, "NotImplemented")

