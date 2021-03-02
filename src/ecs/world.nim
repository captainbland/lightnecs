import sequtils
import tables
import ../components/component
import ../systems/my_system
import entity

type
    World* = ref object of RootObj
        system_components: Table[MySystem, ComponentType]
        entities: seq[Entity]
    
template newWorld*(): World =
    let myTable = initTable[MySystem, ComponentType]()
    var mySeq: seq[Entity] = newSeq[Entity]()
    World(system_components: myTable, entities: mySeq)

proc registerSystem*(world: var World, system: MySystem, componentType: ComponentType): World =
    world.system_components[system] = componentType
    return world

proc addEntity*(world: var World, entity: Entity): World =
    world.entities.add(entity)
    return world

proc runSystems*(world: var World) =
    for sys, component_type in world.system_components:
        for entity in world.entities:
            for component in entity.getComponents(component_type):
                sys.run(component)