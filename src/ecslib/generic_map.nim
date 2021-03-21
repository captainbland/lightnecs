import ../components/printable_component
import ../components/appending_component
import ../components/draw_rect_component
import component_list

import macros
import strutils
import sequtils
import sugar

proc generateAccessors(map_name: string, container_name: string, type_name: string): NimNode {.compileTime.} =
  nnkStmtList.newTree(
    parseExpr("proc get$3(self: $1): $2[$3] = self.my_$3".format(map_name, container_name, type_name)),
    parseExpr("proc put$3(self: $1, component: $2[$3]) = self.my_$3 = component".format(map_name, container_name, type_name)))

proc generateFacade(map_name: string): NimNode {.compileTime.} =
    nnkStmtList.newTree(
      parseExpr("template `[]`* (self: $1, param: untyped): untyped = `get param`(self)".format(map_name)),
      parseExpr("template `[]=` (self: $1, param: untyped, value: untyped): untyped = `put param`(self, value)".format(map_name)))

###Generates e.g. 
# type MyMap* = ref object of RootObj
#     my_PrintableComponent: ComponentList[PrintableComponent]
#     my_AppendingComponent: ComponentList[AppendingComponent]

# proc getPrintableComponent(self: MyMap): ComponentList[PrintableComponent] = self.my_PrintableComponent
# proc putPrintableComponent(self: MyMap, component: ComponentList[PrintableComponent]) = self.my_PrintableComponent = component 

# template `[]` (self: MyMap, param: untyped): untyped = `get param`(self)
# template `[]=` (self: MyMap, param: untyped, value: untyped): untyped = `put param`(self, value)

macro generateGenericMap(map_name: string, my_container: untyped, my_types: varargs[untyped]): untyped =
  var recList = nnkRecList.newTree()
  let my_container_name = my_container.strVal
  let my_map_name = map_name.strVal
  echo treeRepr my_types
  for my_type in my_types:
    let my_type_name = my_type.strVal
    
    recList.add(nnkIdentDefs.newTree(
                newIdentNode("my_$1".format(my_type_name)),
                nnkBracketExpr.newTree(
                  newIdentNode(my_container_name),
                  newIdentNode(my_type_name)
                ),
                newEmptyNode()
              ))

  
  var statement_list = nnkStmtList.newTree(
  nnkTypeSection.newTree(
    nnkTypeDef.newTree(
      nnkPostfix.newTree(
        newIdentNode("*"),
        newIdentNode(my_map_name)
      ),
      newEmptyNode(),
      nnkRefTy.newTree(
        nnkObjectTy.newTree(
          newEmptyNode(),
          nnkOfInherit.newTree(
            newIdentNode("RootObj")
          ),
          recList
        )
      )
    )
  ))

  for my_type in my_types:
    let my_type_name = my_type.strVal
    statement_list.add(generateAccessors(my_map_name, my_container_name, my_type_name))

  statement_list.add(generateFacade(my_map_name))
  
  return statement_list


generateGenericMap("MyMap", ComponentList, PrintableComponent, AppendingComponent)




var my_map = MyMap()


my_map[PrintableComponent] = ComponentList[PrintableComponent]()
