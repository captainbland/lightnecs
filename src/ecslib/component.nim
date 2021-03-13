import hashes
import intsets


type
    Component* = object
        component_type*: string
        
    ComponentType* = int16

    Signature* = IntSet

    HasComponentType* = concept comp, comp_type
        getComponentType[comp](): comp_type


proc newSignature*(component_types: varargs[ComponentType]): IntSet =
    var my_intset = initIntSet()
    for comp_type in component_types:
        my_intset.incl(comp_type)
    return my_intset
