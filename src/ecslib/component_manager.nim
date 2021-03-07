import component
import entity
import options
import tables
import hashes

var component_type_counter: ComponentType = 0
type 
    ComponentTypeMap = ref object of RootObj
        component_types*: Table[Hash, ComponentType]

proc getComponentTypeMap(): ComponentTypeMap =
    #global considered ok because component types are a program-level concept
    var type_mape {.global.}: ComponentTypeMap = ComponentTypeMap(component_types: initTable[Hash, ComponentType]())


type
    ComponentManager*[T] = ref object of RootObj
        entity_index_list: array[MAX_ENTITIES, int]
        component_list: seq[T]
        component_type_id: ComponentType
    
proc newComponentManager[T](): ComponentManager[T] =
    component_type_counter += 1

    return ComponentManager[T](component_list: @[], component_type_id: component_type_counter)

proc getType*[T](componentManager: ComponentManager[T]) = 
    componentManager.component_type_id

#singleton each component manager
proc getComponentManager*[T](): ComponentManager[T] = 
    # static considered ok here because component types are considered to be program-level objects
    var thisComponentManager  {.global.}: ComponentManager[T] = newComponentManager[T]()
    return thisComponentManager

proc addEntityComponent*[T](self: ComponentManager[T], entity: Entity, component: T): void = 
    #probably very not thread safe
    let linked_index = self.component_list.len()
    self.entity_index_list[entity] = linked_index
    self.component_list.add(component)

proc getComponent*[T](self: ComponentManager[T], entity: Entity): T =
    let linked_index = self.entity_index_list[entity]
    self.component_list[linked_index]
