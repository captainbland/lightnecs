import world
import types



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


proc newEntityWithComponentsImpl(the_world: World, components: tuple): Entity {.discardable.} =
    let entity_builder = the_world.newEntityBuilder
    for x in components.fields:
        discard entity_builder.withComponent(x)
    entity_builder.done()

proc newEntityWithComponentsImpl[T](the_world: World, component: T): Entity {.discardable.} =
    let entity_builder = the_world.newEntityBuilder().withComponent(component).done()

template createEntity*(the_world: World, components: varargs[untyped]): untyped =
    newEntityWithComponentsImpl(the_world, (components))


proc newSystemNeedingComponentsImpl[T](the_world: World, the_system: T, components: tuple): T =
    let system_builder = newSystemBuilder(the_world, the_system)
    for x in components.fields:
        discard system_builder.needsComponent(x)
    system_builder.done()


proc newSystemNeedingComponentsImpl[T, S](the_world: World, the_system: T, component: S): T =
    newSystemBuilder(the_world, the_system).needsComponent(component).done()


template createSystem*(the_world: World, the_system: untyped, components: varargs[untyped]): untyped =
    newSystemNeedingComponentsImpl(the_world, the_system, (components))
