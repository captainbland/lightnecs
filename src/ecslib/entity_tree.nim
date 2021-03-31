import children_component
import parent_component
import types 
import sugar
import options
import world
import tables
import strutils

proc maybeGet[K,V](table: Table[K,V], key:K): Option[V] =
    if not table.contains(key):
        return none(V)
    else:
        return some(table[key])

proc orElse[T](opt: Option[T], exec: proc():void): void =
    if opt.isNone: 
        exec()

proc orElseGet[T](opt: Option[T], exec: proc():T): T =
    if opt.isNone: 
        exec()
    else:
        opt.get()
        
proc getChild*(world: World, entity: Entity, name: string): Option[Entity] =
    queryComponent[ChildrenComponent](world, entity)
        .map(c => c.children.maybeGet(name))
        .flatten()

proc addChild*(world: World, parent: Entity, child: Entity, label: string): void =
    var childrenComponent = queryComponent[ChildrenComponent](world, parent)
        .orElseGet(() => addComponent[ChildrenComponent](world, parent, newChildrenComponent()))

    childrenComponent.children[label] = child

proc findEntity*(world: World, path: string): Option[Entity] =
    if path == "/": return some(world.globalEntity)

    let split_path = path.split("/")[1..^1]

    var last_entity = world.globalEntity
    echo split_path
    for path_part in split_path:
        let this_child = getChild(world, last_entity, path_part)

        if this_child.isSome:
            last_entity = this_child.get()
        else: return none(Entity)
    return some(last_entity)

proc removeChild*(world: World, parent: Entity, label: string): void =
    var childrenComponent = queryComponent[ChildrenComponent](world, parent)
    if childrenComponent.isSome:
        childrencomponent.get().children.del(label)