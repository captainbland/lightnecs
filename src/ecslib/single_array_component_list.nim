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

#single array component list

type
    AbstractComponentList* = ref object of RootObj
        component_type_id: ComponentType

    ComponentList*[T] = ref object of AbstractComponentList
        component_list: array[MAX_ENTITIES, T]



proc hash*(self: AbstractComponentList): Hash =
    self.component_type_id.hash()

proc newComponentList*[T](): ComponentList[T] =
    var list = ComponentList[T]()

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
    self.component_list[entity] = component

proc getComponentFromList*[T](self: ComponentList[T], entity: Entity): T {.inline.} =
    self.component_list[entity]

proc queryComponentFromList*[T](self: ComponentList[T], entity: Entity): Option[T] {.inline.}=
    let component = self.component_list[entity]
    return if component != nil:
         some(self.component_list[entity])
    else: none(T)


proc replaceComponentInList*[T](self: ComponentList[T], entity: Entity, component: T) =
    self.component_list[entity] = component


proc removeComponentFromList*[T](self: ComponentList[T], entity: Entity) =
    self.component_list[entity] = nil



proc getComponentRemover*[T](self: ComponentList[T]): proc(entity: Entity) =
    proc componentRemover(entity: Entity) =
        removeComponentFromList(self, entity)

        #echo "destroying entity", entity
    return componentRemover 





proc getSerialiser*[T](self: ComponentList[T]): proc(): JsonNode =
    let type_name = name(T)
    proc serialise(): JsonNode =
        var my_json_node: JsonNode = %*{}
        # for entity_id in 0..MAX_ENTITIES-1:
        #     let component = self.component_list[entity]
        #     when compiles %component:
        #         my_json_node[intToStr(entity_id)] = %component
        return %*{type_name: my_json_node}
    return serialise # note not having this line results in a sigsev!?
        