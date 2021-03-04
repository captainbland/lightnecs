import ../ecslib/component

import tables

type
    Entity* = object
        components: Table[ComponentType, seq[Component]]

proc newEntity*(): Entity =
    Entity(components: initTable[ComponentType, seq[Component]]() )

proc addComponent*(entity: var Entity, component: Component): Entity =
    var this_seq = entity.components.mgetOrPut(component.typename(), newSeq[Component]())
    this_seq.add(component)
    entity.components[component.typename()] = this_seq
    return entity

proc getComponents*(entity: Entity, componentType: ComponentType): seq[Component] =
    entity.components.getOrDefault(componentType, newSeq[Component]())