import component
import entity
import options

const COMPONENT_MANAGER_MAX_ARRAY_SIZE = 10000

type
    ComponentManager*[T] = ref object of RootObj
        entity_index_list: array[COMPONENT_MANAGER_MAX_ARRAY_SIZE, int]
        component_list: seq[T]
    
proc newComponentManager[T](): ComponentManager[T] =
    return ComponentManager[T](component_list: @[])

#singleton each component manager
proc getComponentManager*[T](): ComponentManager[T] = 
    var thisComponentManager  {.global.}: ComponentManager[T] = newComponentManager[T]()
    return thisComponentManager

proc addEntityComponent*[T](self: ComponentManager[T], entity: Entity, component: T): void = 
    #probably very not thread safe
    let linked_index = self.component_list.len()
    self.entity_index_list[entity.id] = linked_index
    self.component_list.add(component)

proc getComponent*[T](self: ComponentManager[T], entity: Entity): T =
    let linked_index = self.entity_index_list[entity.id]
    self.component_list[linked_index]
