import world
import entity
import component

type
    EntityBuilder* = ref object of RootObj
        my_world: World
        my_entity: Entity

proc newEntityBuilder*(the_world: World): EntityBuilder =
    return EntityBuilder(my_entity: the_world.createEntity(), my_world: the_world)

proc withComponent*[T](self: EntityBuilder, component: T): EntityBuilder =
     addComponent[T](self.my_world, self.my_entity, component)
     return self

proc done*(self: EntityBuilder): Entity = self.my_entity

type 
    SystemBuilder*[T] = ref object of RootObj
        my_world: World
        my_system: T
        component_types: seq[ComponentType]

proc newSystemBuilder*[T](the_world: World, sys: T): SystemBuilder[T] =
    discard the_world.registerSystem(sys)
    return SystemBuilder[T](my_world: the_world, my_system: sys, component_types: @[])

proc needsComponent*[T, S](self: SystemBuilder[T], my_component_type: S): SystemBuilder[T] =
    self.component_types.add(getComponentType[S](self.my_world))
    return self

proc done*[T](self: SystemBuilder[T]): T =

    self.my_world.setSystemSignature(self.my_system, newSignature(self.component_types))

    return self.my_system