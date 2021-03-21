import world
import entity
import component

type
    EntityBuilder*[CompListT] = ref object of RootObj
        my_world: World[CompListT]
        my_entity: Entity

proc newEntityBuilder*[CompListT](the_world: World[CompListT]): EntityBuilder =
    return EntityBuilder(my_entity: the_world.createEntity(), my_world: the_world)

proc withComponent*[T](self: EntityBuilder, component: T): EntityBuilder =
     addComponent[T](self.my_world, self.my_entity, component)
     return self

proc done*(self: EntityBuilder): Entity = self.my_entity

type 
    SystemBuilder*[T, CompListT] = ref object of RootObj
        my_world: World[CompListT]
        my_system: T
        component_types: seq[ComponentType]

proc newSystemBuilder*[T, CompListT](the_world: World[CompListT], sys: T): SystemBuilder[T, CompListT] =
    discard the_world.registerSystem(sys)
    return SystemBuilder[T](my_world: the_world, my_system: sys, component_types: @[])

proc needsComponent*[T, S, CompListT](self: SystemBuilder[T, CompListT], my_component_type: CompListT): SystemBuilder[T, CompListT] =
    self.component_types.add(getComponentType[S](self.my_world))
    return self

proc done*[T, CompListT](self: SystemBuilder[T, CompListT]): T =

    self.my_world.setSystemSignature(self.my_system, newSignature(self.component_types))

    return self.my_system


proc newEntityWithComponentsImpl[CompListT](the_world: World[CompListT], components: tuple): Entity {.discardable.} =
    let entity_builder = the_world.newEntityBuilder
    for x in components.fields:
        discard entity_builder.withComponent(x)
    entity_builder.done()

proc newEntityWithComponentsImpl[T, CompListT](the_world: World[CompListT], component: T): Entity {.discardable.} =
    let entity_builder = the_world.newEntityBuilder().withComponent(component).done()

template createEntity*[CompListT](the_world: World[CompListT], components: varargs[untyped]): untyped =
    newEntityWithComponentsImpl(the_world, (components))


proc newSystemNeedingComponentsImpl[T, CompListT](the_world: World[CompListT], the_system: T, components: tuple): T =
    let system_builder = newSystemBuilder(the_world, the_system)
    for x in components.fields:
        discard system_builder.needsComponent(x)
    system_builder.done()


proc newSystemNeedingComponentsImpl[T, S, CompListT](the_world: World[CompListT], the_system: T, component: S): T =
    let system_builder = newSystemBuilder(the_world, the_system).needsComponent(component).done()


template createSystem*[CompListT](the_world: World[CompListT], the_system: untyped, components: varargs[untyped]): untyped =
    newSystemNeedingComponentsImpl(the_world, the_system, (components))
