import options
import json

import tables
export tables.`[]`

import hashes
import typetraits
import strutils
import types

var component_type_counter: ComponentType = 0

type

    ComponentList*[T] = ref object of AbstractComponentList
        entity_index_list: array[MAX_ENTITIES, int]
        component_list: seq[T]
        next_index_to_use: seq[int]


        
const DEFAULT_EMPTY = -1
const REMOVED = -2

proc hash*(self: AbstractComponentList): Hash =
    self.component_type_id.hash()

proc newComponentList*[T](): ComponentList[T] =
    component_type_counter += 1
    var list = ComponentList[T](component_list: @[],
     component_type_id: component_type_counter,
     next_index_to_use: @[])
    for x in list.entity_index_list.mitems(): x = DEFAULT_EMPTY

    return list

proc getComponentTypeFromList*[T](self: ComponentList[T]): ComponentType = 
    self.component_type_id

#singleton each component manager
proc getComponentList*[T](): ComponentList[T] =  
    # static considered ok here because component types are considered to be program-level objects
    var thisComponentList  {.threadVar.}: Option[ComponentList[T]] 
    if thisComponentList.isNone:
        thisComponentList = some(newComponentList[T]())
    return thisComponentList.get()

proc addEntityComponent*[T](self: ComponentList[T], entity: Entity, component: T): void = 
    #probably very not thread safe


    if self.next_index_to_use.len() == 0 or self.next_index_to_use[self.next_index_to_use.len()-1] > 0:
        let linked_index = self.component_list.len()
        self.entity_index_list[entity] = linked_index
        self.component_list.add(component)
    else: 
        let linked_index = self.next_index_to_use.pop()
        self.component_list[linked_index] = component
        self.entity_index_list[entity] = linked_index

proc getComponentFromList*[T](self: ComponentList[T], entity: Entity): T {.inline.} =
    let linked_index = self.entity_index_list[entity]
    self.component_list[linked_index]

proc queryComponentFromList*[T](self: ComponentList[T], entity: Entity): Option[T] {.inline.} =
    let linked_index = self.entity_index_list[entity]
    return if linked_index > DEFAULT_EMPTY:
         some(self.component_list[linked_index])
    else: none(T)


proc replaceComponentInList*[T](self: ComponentList[T], entity: Entity, component: T) =
    let linked_index = self.entity_index_list[entity]
    self.component_list[linked_index] = component

proc removeComponentFromList*[T](self: ComponentList[T], entity: Entity) =
    let linked_index = self.entity_index_list[entity]
    self.entity_index_list[entity] = REMOVED
    self.next_index_to_use.add(linked_index)


proc getComponentRemover*[T](self: ComponentList[T]): proc(entity: Entity) =
    proc componentRemover(entity: Entity) =
        removeComponentFromList(self, entity)

        #echo "destroying entity", entity
    return componentRemover 





proc getSerialiser*[T](self: ComponentList[T]): proc(): JsonNode =
    let type_name = name(T)
    proc serialise(): JsonNode =
        var my_json_node: JsonNode = %*{}
        for entity_id in 0..MAX_ENTITIES-1:
            let linked_index = self.entity_index_list[entity_id]

            if linked_index == DEFAULT_EMPTY: 
                continue # we're done when we get the first default empty
            if linked_index > DEFAULT_EMPTY and self.component_list.len() > 0:
                let component = self.component_list[linked_index]
                when compiles %component:
                    my_json_node[intToStr(entity_id)] = %component
        return %*{type_name: my_json_node}
    return serialise # note not having this line results in a sigsev!?
        