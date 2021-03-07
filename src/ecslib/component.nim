import re
import hashes
import math
import intsets

const MAX_COMPONENT_TYPES = 2^8

type
    Component* = object
        component_type*: string
        
    ComponentType* = int8

    NotImplementedException* = object of Exception

    Signature* = IntSet

    HasComponentType* = concept comp, comp_type
        getComponentType(comp): comp_type



# proc camel_to_const_case(my_string: string): string  {.compileTime.} =
#     my_string.replace(re"([a-z])([A-Z])", "?_?")  

proc print_typename(typename: string): void {.compileTime.} =
    echo "here's the thing: ", typename

template generate_typeinfo*(my_type: untyped, component_type: ComponentType): untyped =
    method typename*(x: my_type): ComponentType = 
        return component_type



method typename*(x: Component): ComponentType = 
    raise newException(NotImplementedException, "NotImplemented")

