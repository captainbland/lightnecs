import tables
import sets

import component_list
import system_manager
import entity_manager
import intsets
import options
import json
import strutils
import my_system
import types


proc createEntity*(self: World): Entity =
    return self.entity_manager.newEntity()

proc getWorld*(): World =
    # 1 world per app that's the rules
    var world = World(
        system_manager: newSystemManager(),
        entity_manager: newEntityManager(),
        am_world: "i am a world",
        component_list_destroyers: initTable[ComponentType, proc(entity: Entity)](),
        component_list_serialisers: initTable[ComponentType, proc(): JsonNode](),

    )
    world.globalEntity = world.createEntity()
    return world


proc addComponent*[T](self: World, entity: Entity, component: T): T {.discardable.} =
    let my_component_type = getComponentList[T]().getComponentTypeFromList()
    let my_component_list = getComponentList[T]()

    my_component_list.addEntityComponent(entity, component)
    var signature = self.entityManager.getSignature(entity)

    signature.incl(my_component_type)
    self.entity_manager.setSignature(entity, signature)
    self.system_manager.entitySignatureChanged(entity, signature)
    self.component_list_destroyers[my_component_type] = my_component_list.getComponentRemover()
    self.component_list_serialisers[my_component_type] = my_component_list.getSerialiser()
    return component


proc removeComponent*[T](self: World, entity: Entity): void = 
    getComponentList[T]().removeComponentFromList(entity)


proc setComponent*[T](self: World, entity: Entity, component: T): void = 
    let my_component_list = getComponentList[T]()
    replaceComponentInList[T](my_component_list, entity, component)

   

proc getComponent*[T](self: World, entity: Entity): T {.inline.} =
    return getComponentList[T]().getComponentFromList(entity)

#note: using queryComponent is about half as fast as getComponent, but is safer
proc queryComponent*[T](self: World, entity: Entity): Option[T] {.inline.} =
    return getComponentList[T]().queryComponentFromList(entity)

#fixme... proc getComponentOrSet*[T](self: World, entity: Entity): T

proc getComponentType*[T](self: World): ComponentType =
    return getComponentList[T]().getComponentTypeFromList()

proc registerSystem*[T](self: World, sys: T): T =
    sys.world = self
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
