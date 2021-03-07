import re
import hashes
import math
import intsets
import typeutil

const MAX_COMPONENT_TYPES = 2^8

type
    Component* = object
        component_type*: string
        
    ComponentType* = int8

    NotImplementedException* = object of Exception

    Signature* = IntSet

    HasComponentType* = concept comp, comp_type
        getComponentType[comp](): comp_type


proc newSignature*(component_types: varargs[ComponentType]): IntSet =
    var my_intset = initIntSet()
    for comp_type in component_types:
        my_intset.incl(comp_type)
    return my_intset

# proc camel_to_const_case(my_string: string): string  {.compileTime.} =
#     my_string.replace(re"([a-z])([A-Z])", "?_?")  

proc print_typename(typename: string): void {.compileTime.} =
    echo "here's the thing: ", typename

generate_typeinfo(Component)
