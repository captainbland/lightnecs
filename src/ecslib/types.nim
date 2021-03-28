import tables

import hashes
import intsets
import sets
import deques
import json

const MAX_ENTITIES* = 30000

type
    Entity* = int16


type
    EntityBuilder* = ref object of RootObj
        my_world*: World
        my_entity*: Entity

    AbstractComponentList* = ref object of RootObj
        component_type_id*: ComponentType

    MySystem* = ref object of RootObj
        name*: string
        hash*: Hash
        entities*: HashSet[Entity]
        world*: World
    
    SystemType* = Hash

    World* = ref object of RootObj
        #component_manager: ComponentManager
        system_manager*: SystemManager
        entity_manager*: EntityManager
        am_world*: string
        component_list_destroyers*: Table[ComponentType, proc(entity: Entity)]
        component_list_serialisers*: Table[ComponentType, proc(): JsonNode]
        component_lists*: Table[ComponentType, AbstractComponentList]

    SystemManager* = ref object of RootObj 
        signatures*: Table[SystemType, Signature]
        systems*: Table[SystemType, MySystem]

    EntityManager* = ref object of RootObj
        signatures*: array[MAX_ENTITIES, Signature]
        next_id_queue*: Deque[Entity]

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