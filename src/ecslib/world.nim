import tables
import sets

import ../ecslib/component
import entity

import component_list
import system_manager
import entity_manager
import intsets
import options
import json
import strutils
import my_system

type
    World*[CompListT] = ref object of RootObj
        #component_manager: ComponentManager
        system_manager: SystemManager
        entity_manager: EntityManager
        am_world*: string
        component_list_destroyers: Table[ComponentType, proc(entity: Entity)]
        component_list_serialisers: Table[ComponentType, proc(): JsonNode]
        component_lists: CompListT
        


proc getWorld*[CompListT](component_lists: CompListT): World[CompListT] =
    # 1 world per app that's the rules
    var world = World[CompListT](
        system_manager: newSystemManager(),
        entity_manager: newEntityManager(),
        am_world: "i am a world",
        component_list_destroyers: initTable[ComponentType, proc(entity: Entity)](),
        component_list_serialisers: initTable[ComponentType, proc(): JsonNode](),
        component_lists: component_lists
    )

    return world

proc createEntity*[CompListT](self: World[CompListT]): Entity =
    return self.entity_manager.newEntity()


proc addComponent*[T, CompListT](self: World[CompListT], entity: Entity, component: T): void =
    let my_component_type = self.component_lists[T].getComponentTypeFromList()
    let my_component_list = self.component_lists[T]

    my_component_list.addEntityComponent(entity, component)
    var signature = self.entityManager.getSignature(entity)

    signature.incl(my_component_type)
    self.entity_manager.setSignature(entity, signature)
    self.system_manager.entitySignatureChanged(entity, signature)
    self.component_list_destroyers[my_component_type] = my_component_list.getComponentRemover()
    self.component_list_serialisers[my_component_type] = my_component_list.getSerialiser()


proc removeComponent*[T, CompListT](self: World[CompListT], entity: Entity): void = 
    getComponentList[T]().removeComponentFromList(entity)


proc setComponent*[T, CompListT](self: World[CompListT], entity: Entity, component: T): void = 
    let my_component_list = getComponentList[T]()
    replaceComponentInList[T](my_component_list, entity, component)

   

proc getComponent*[T, CompListT](self: World[CompListT], entity: Entity): T {.inline.} =
    return self.component_lists[T].getComponentFromList(entity)

#note: using queryComponent is about half as fast as getComponent, but is safer
proc queryComponent*[T, CompListT](self: World[CompListT], entity: Entity): Option[T] {.inline.} =
    return self.component_lists[T].queryComponentFromList(entity)


template getComponentType*(self:untyped, typename: untyped): untyped =
    return getComponentTypeFromList(self.component_lists[typename])

proc registerSystem*[T, CompListT](self: World[CompListT], sys: T): T =
    return self.system_manager.registerSystem(sys)

proc setSystemSignature*[T, CompListT](self: World[CompListT], sys: T, my_signature: Signature): void =
    setSignatureFromManager[T](self.system_manager, sys, my_signature)

proc destroyEntity*[CompListT](self: World[CompListT], entity:Entity): void =
    for destroyer in self.component_list_destroyers.values:
        destroyer(entity)
    self.system_manager.entityDestroyed(entity)

proc serialise*[CompListT](self: World[CompListT]): string =
    let serialisers = self.component_list_serialisers
    var world_json = %*{}
    for comp_type, serialiser in serialisers:
        if serialiser == nil: echo "serialiser is nil!"
        else: world_json[intToStr(comp_type)] = serialiser()
    return $world_json
