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
    World* = ref object of RootObj
        #component_manager: ComponentManager
        system_manager: SystemManager
        entity_manager: EntityManager
        am_world*: string
        component_list_destroyers: Table[ComponentType, proc(entity: Entity)]
        component_list_serialisers: Table[ComponentType, proc(): JsonNode]
        component_lists: Table[ComponentType, AbstractComponentList]

proc getWorld*(): World =
    # 1 world per app that's the rules
    var world = World(
        system_manager: newSystemManager(),
        entity_manager: newEntityManager(),
        am_world: "i am a world",
        component_list_destroyers: initTable[ComponentType, proc(entity: Entity)](),
        component_list_serialisers: initTable[ComponentType, proc(): JsonNode](),

    )

    return world

proc createEntity*(self: World): Entity =
    return self.entity_manager.newEntity()


proc addComponent*[T](self: World, entity: Entity, component: T): void =
    let my_component_type = getComponentList[T]().getComponentTypeFromList()
    let my_component_list = getComponentList[T]()

    my_component_list.addEntityComponent(entity, component)
    var signature = self.entityManager.getSignature(entity)

    signature.incl(my_component_type)
    self.entity_manager.setSignature(entity, signature)
    self.system_manager.entitySignatureChanged(entity, signature)
    self.component_list_destroyers[my_component_type] = my_component_list.getComponentRemover()
    self.component_list_serialisers[my_component_type] = my_component_list.getSerialiser()

proc removeComponent*[T](self: World, entity: Entity): void = discard

proc getComponent*[T](self: World, entity: Entity): T =
    return getComponentList[T]().getComponentFromList(entity)

#note: using queryComponent is about half as fast as getComponent, but is safer
proc queryComponent*[T](self: World, entity: Entity): Option[T] =
    return getComponentList[T]().queryComponentFromList(entity)


proc getComponentType*[T](self: World): ComponentType =
    return getComponentList[T]().getComponentTypeFromList()

proc registerSystem*[T](self: World, sys: T): T =
    return self.system_manager.registerSystem(sys)

proc setSystemSignature*[T](self: World, sys: T, my_signature: Signature): void =
    setSignatureFromManager[T](self.system_manager, sys, my_signature)

proc destroyEntity*(self: World, entity:Entity): void =
    for destroyer in self.component_list_destroyers.values:
        destroyer(entity)
    self.system_manager.entityDestroyed(entity)

proc serialise*(self: World): string =
    let serialisers = self.component_list_serialisers
    var world_json = %*{}
    for comp_type, serialiser in serialisers:
        if serialiser == nil: echo "serialiser is nil!"
        else: world_json[intToStr(comp_type)] = serialiser()
    return $world_json
