import sequtils
import tables
import sugar
import sets

import ../ecslib/component
import ../ecslib/my_system
import entity

import component_list
import system_manager
import entity_manager
import intsets

type
    World* = ref object of RootObj
        #component_manager: ComponentManager
        system_manager: SystemManager
        entity_manager: EntityManager
        am_world*: string

proc getWorld*(): World =
    # 1 world per app that's the rules
    var world {.global.} = World(
        system_manager: newSystemManager(),
        entity_manager: newEntityManager(),
        am_world: "i am a world"
    )

    return world

proc createEntity*(self: World): Entity =
    return self.entity_manager.newEntity()

proc addComponent*[T](self: var World, entity: Entity, component: T): void =
    getComponentList[T]().addEntityComponent(entity, component)
    var signature = self.entityManager.getSignature(entity)
    signature.incl(getComponentList[T]().getComponentTypeFromList())
    self.entity_manager.setSignature(entity, signature)
    self.system_manager.entitySignatureChanged(entity, signature)

proc removeComponent*[T](self: World, entity: Entity): void = discard

proc getComponent*[T](self: World, entity: Entity): T =
    return getComponentList[T]().getComponentFromList(entity)


proc getComponentType*[T](self: World): ComponentType =
    return getComponentList[T]().getComponentTypeFromList()

proc registerSystem*[T](self: World, sys: T): T =
    return self.system_manager.registerSystem(sys)

proc setSystemSignature*[T](self: World, sys: T, my_signature: Signature): void =
    setSignatureFromManager[T](self.system_manager, sys, my_signature)