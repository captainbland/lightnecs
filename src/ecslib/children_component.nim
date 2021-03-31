import ../ecslib/types
import tables
type
    ChildrenComponent* = ref object of RootObj 
        children*: Table[string, Entity]

proc newChildrenComponent*(): ChildrenComponent = ChildrenComponent(children: initTable[string, Entity]())