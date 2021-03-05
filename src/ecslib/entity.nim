import ../ecslib/component

import tables
import sugar
import sequtils
import sets

##DANGER, THREAD SAFETY. FIXME
var id_gen = 0

type

    Entity* = ref object of RootObj
        components: Table[ComponentType, seq[Component]]
        component_types: HashSet[ComponentType]
        component_type_combinations*: HashSet[HashSet[ComponentType]]
        id*: int64

proc newEntity*(): Entity =
    id_gen += 1
    Entity(components: initTable[ComponentType, seq[Component]](), id: id_gen)

proc addComponent*(entity: var Entity, component: Component): var Entity =
    var this_seq = entity.components.mgetOrPut(component.typename(), newSeq[Component]())
    this_seq.add(component)
    entity.components[component.typename()] = this_seq
    entity.component_types.incl(component.typename())
    entity.component_type_combinations.incl(entity.component_types.deepCopy)
    return entity

proc hasAllComponents*(entity: Entity, componentTypes: seq[ComponentType]): bool =
    return componentTypes.map((key) => entity.components.hasKey(key)).foldl(a and b)

proc getComponents*(entity: Entity): Table[ComponentType, seq[Component]] =
    entity.components

proc getComponents*(entity: Entity, componentType: ComponentType): ptr seq[Component] =
    addr entity.components[componentType]

proc getComponentTypes*(entity: Entity): HashSet[ComponentType] =
    entity.component_types