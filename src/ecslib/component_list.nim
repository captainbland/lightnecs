import component
import entity
import options
import json

import tables
export tables.`[]`

import hashes
import typetraits
import strutils
#import json

var component_type_counter: ComponentType = 0

type
    AbstractComponentList* = ref object of RootObj
        component_type_id: ComponentType

    ComponentList*[T] = ref object of AbstractComponentList
        entity_index_list: array[MAX_ENTITIES, int]
        component_list: seq[T]


        
const DEFAULT_EMPTY = -1
const REMOVED = -2

proc hash*(self: AbstractComponentList): Hash =
    self.component_type_id.hash()

proc newComponentList*[T](): ComponentList[T] =
    component_type_counter += 1
    var list = ComponentList[T](component_list: @[], component_type_id: component_type_counter)
    for x in list.entity_index_list.mitems(): x = DEFAULT_EMPTY
    return list

proc getComponentTypeFromList*[T](self: ComponentList[T]): ComponentType = 
    self.component_type_id

#singleton each component manager
proc getComponentList*[T](): ComponentList[T] = 
    # static considered ok here because component types are considered to be program-level objects
    var thisComponentList  {.global.}: ComponentList[T] = newComponentList[T]()
    return thisComponentList

proc addEntityComponent*[T](self: ComponentList[T], entity: Entity, component: T): void = 
    #probably very not thread safe
    let linked_index = self.component_list.len()
    self.entity_index_list[entity] = linked_index
    self.component_list.add(component)

proc getComponentFromList*[T](self: ComponentList[T], entity: Entity): T =
    let linked_index = self.entity_index_list[entity]
    self.component_list[linked_index]

proc maybeGetComponentFromList*[T](self: ComponentList[T], entity: Entity): Option[T] =
    let linked_index = self.entity_index_list[entity]
    return if linked_index > DEFAULT_EMPTY: some(self.component_list[linked_index]) else: none(T)

proc getComponentRemover*[T](self: ComponentList[T]): proc(entity: Entity) =
    proc removeComponentFromList(entity: Entity) =
        let linked_index = self.entity_index_list[entity]
        
        self.entity_index_list[entity] = REMOVED

        echo "destroying entity", entity
    return removeComponentFromList 


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
                my_json_node[intToStr(entity_id)] = %component
        return %*{type_name: my_json_node}
    return serialise # note not having this line results in a sigsev!?
        