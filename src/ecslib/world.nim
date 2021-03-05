import sequtils
import tables
import sugar


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
        system_components: Table[MySystem, seq[ComponentType]]
        entities: seq[Entity]
    
template newWorld*(): World =
    let myTable = initTable[MySystem, seq[ComponentType]]()
    var mySeq: seq[Entity] = newSeq[Entity]()
    World(system_components: myTable, entities: mySeq)

proc registerSystem*(world: var World, system: MySystem, componentType: varargs[ComponentType]): var World =
    world.system_components[system] = @componentType
    return world

proc addEntity*(world: var World, entity: Entity): var World =
    world.entities.add(entity)
    return world

proc runSystems*(world: var World) =
    for sys, component_types in world.system_components:
        # echo "Found system ", sys.name, " with ", component_types
        let entities = world.entities#.filter((entity)=>entity.hasAllComponents(component_types)) 
        sys.run(entities)