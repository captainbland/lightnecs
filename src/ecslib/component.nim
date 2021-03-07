import hashes
import intsets
import typeutil


type
    Component* = object
        component_type*: string
        
    ComponentType* = int8

    Signature* = IntSet

    HasComponentType* = concept comp, comp_type
        getComponentType[comp](): comp_type


proc newSignature*(component_types: varargs[ComponentType]): IntSet =
    var my_intset = initIntSet()
    for comp_type in component_types:
        my_intset.incl(comp_type)
    return my_intset

proc print_typename(typename: string): void {.compileTime.} =
    echo "here's the thing: ", typename

generate_typeinfo(Component)
