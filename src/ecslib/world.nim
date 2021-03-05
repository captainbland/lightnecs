import sequtils
import tables
import sugar
import sets

import ../ecslib/component
import ../ecslib/my_system
import entity
import ../systems/printing_system


# type
#     World*[T] = ref object of RootObj
#         system: T
#         component_types: seq[ComponentType]
#         entities: seq[Entity]


# proc newWorldSystem*[T](system: T, componentTypes: varargs[string, `ComponentType`]): World[T] =
#     World[T](
#         system: system,
#         component_types: @componentTypes,
#         entities: @[]
#     )

# proc addEntity*[T](world: var World[T], entity: Entity): World =
#     world.entities.add(entity)
#     return world

# proc runSystems*[T](world: var World[T]) =
#     for entity in world.entities:
#         let entities = world.entities.filter((entity)=>entity.hasAllComponents(world.component_types))
#         system.run(entities)

# proc registerSystem*[T](world: var World, system: T, componentType: varargs[string, `ComponentType`]): World =
#     world.system_components[system] = @componentType
#     return world

    
# template newWorld*(): World =
#     let myTable = initTable[MySystem, seq[ComponentType]]()
#     var mySeq: seq[Entity] = newSeq[Entity]()
#     World(system_components: myTable, entities: mySeq)

# proc registerSystem*[T](world: var World, system: T, componentType: varargs[string, `ComponentType`]): World =
#     world.system_components[system] = @componentType
#     return world


type
    World* = ref object of RootObj
        system_components: Table[MySystem, HashSet[ComponentType]]
        entities: Table[HashSet[ComponentType], seq[Entity]]
        component_systems: Table[HashSet[ComponentType], MySystem]
    
template newWorld*(): World =
    let system_component_table = initTable[MySystem, HashSet[ComponentType]]()
    let component_system_table = initTable[HashSet[ComponentType], MySystem]()
    let entities = initTable[HashSet[ComponentType], seq[Entity]]()
    World(system_components: system_component_table, component_systems: component_system_table, entities: entities)

proc registerSystem*(world: var World, system: MySystem, componentType: varargs[ComponentType]): var World =
    world.system_components[system] = componentType.toHashSet()
    world.component_systems[componentType.toHashSet()] = system
    return world

proc addEntity*(world: var World, entity: Entity): var World =
    var entity_seq: seq[Entity] = world.entities.mgetOrPut(entity.getComponentTypes(), @[])
    entity_seq.add(entity)
    for component_type_set in entity.component_type_combinations:
        world.entities[component_type_set] = entity_seq
    #echo "adding entity with components ", entity.getComponentTypes()
    return world

proc runSystems*(world: var World) =
    for sys, component_types in world.system_components:
        # echo "Found system ", sys.name, " with ", component_types
        #echo component_types
        if(world.entities.hasKey(component_types)):
            var my_entities: seq[Entity] = world.entities[component_types]
            sys.run(my_entities)