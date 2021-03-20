import ../components/printable_component
import ../components/appending_component
import ../components/draw_rect_component

import macros
import strutils
import sequtils
import sugar

proc `[]`(x: NimNode, kind: NimNodeKind): seq[NimNode] {.compiletime.} =
    return toSeq(x.children).filter(c => c.kind == kind )

proc createAccessorProcs(map_name: string, my_type: string): NimNode {.compileTime.} =
  nnkStmtList.newTree(
  nnkProcDef.newTree(
    newIdentNode("get" & my_type),
    newEmptyNode(),
    newEmptyNode(),
    nnkFormalParams.newTree(
      newIdentNode(my_type),
      nnkIdentDefs.newTree(
        newIdentNode("self"),
        newIdentNode(map_name),
        newEmptyNode()
      )
    ),
    newEmptyNode(),
    newEmptyNode(),
    nnkStmtList.newTree(
      nnkDotExpr.newTree(
        newIdentNode("self"),
        newIdentNode("my_" & my_type)
      )
    )
  ),
  nnkProcDef.newTree(
    newIdentNode("put" & my_type),
    newEmptyNode(),
    newEmptyNode(),
    nnkFormalParams.newTree(
      newEmptyNode(),
      nnkIdentDefs.newTree(
        newIdentNode("self"),
        newIdentNode(map_name),
        newEmptyNode()
      ),
      nnkIdentDefs.newTree(
        newIdentNode("component"),
        newIdentNode(my_type),
        newEmptyNode()
      )
    ),
    newEmptyNode(),
    newEmptyNode(),
    nnkStmtList.newTree(
      nnkAsgn.newTree(
        nnkDotExpr.newTree(
          newIdentNode("self"),
          newIdentNode("my_" & my_type)
        ),
        newIdentNode("component")
      )
    )
  ))

proc createTemplateSugar(map_name: string): NimNode {.compileTime.} =
  nnkStmtList.newTree(
    parseExpr("template `[]` (self: $1, param: untyped): untyped = `get param`(self)".format(map_name)),
    parseExpr("template `[]=` (self: $1, param: untyped, value: untyped): untyped = `put param`(self, value)".format(map_name))
  )

macro createGenericMap(map_name: string, my_types: varargs[typed]): untyped =
  var statementList = nnkStmtList.newTree()
  var recList = nnkRecList.newTree()
  echo treeRepr my_types
  for my_type in my_types:
    var name = my_type.strVal

    var type_name = my_type
    recList.add(nnkIdentDefs.newTree(
                newIdentNode("my_" & name),
                newIdentNode(name),
                newEmptyNode()))


  let typedef = nnkStmtList.newTree(
    nnkTypeSection.newTree(
      nnkTypeDef.newTree(
        nnkPostfix.newTree(
          newIdentNode("*"),
          newIdentNode(map_name.strVal)
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
    )
  )

  statement_list.add(typedef)

  for my_type in my_types:
    var name = my_type.strVal
    statement_list.add(createAccessorProcs(map_name.strVal, name))
  
  statement_list.add(createTemplateSugar(map_name.strVal))

  #statement_list.add quote do: 

  return statement_list

echo "SPACE ==="
echo ""

createGenericMap("MyMap", AppendingComponent, PrintableComponent, DrawRectComponent)



  # template `[]` (self: MyMap, param: untyped): untyped = `get param`(self)
  # template `[]=` (self: MyMap, param: untyped, value: untyped): untyped = `put param`(self, value)



var my_map = MyMap()

my_map[PrintableComponent] = PrintableComponent(my_data: "something")
echo my_map[PrintableComponent].my_data