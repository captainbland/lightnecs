import ../components/printable_component
import ../components/appending_component
import ../components/draw_rect_component
import component_list

import macros
import strutils
import sequtils
import sugar
import typetraits

export macros

proc `[]`(x: NimNode, kind: NimNodeKind): seq[NimNode] {.compiletime.} =
  return toSeq(x.children).filter(c => c.kind == kind)

template as_str*(inp: untyped): untyped = $inp
proc generateAccessors(map_name: string, container_name: string, type_name: string): NimNode {.compileTime.} =
  nnkStmtList.newTree(
    parseExpr("proc get$3(self: $1): $2[$3] = self.my_$3".format(map_name, container_name, type_name)),
    parseExpr("proc set$3(self: $1, component: $2[$3]) = self.my_$3 = component".format(map_name, container_name, type_name)))

proc nameStripped*(val: typedesc): string {.compileTime.}= 
  val.name().strip(chars={'"'})

proc generateFacade(map_name: string, container_name: string): NimNode {.compileTime.} =
    nnkStmtList.newTree(#I'm like 99% sure there's a better way to do this, but I can't think of it so this will have to do
      parseExpr(dedent """
      macro `[]`* (self: $1, param: typedesc): untyped = 
        var x = getTypeInst(param)[1].symbol.getImpl
        let paramName=x[0].as_str()
        echo "paramname is : ", paramname
        parseExpr(self.toStrLit().strVal & ".get" & paramName & "()")
        """.format(map_name)),

      parseExpr(dedent """
      macro `[]=`* (self: $1, param: typedesc, component: untyped): untyped = 
        var x = getTypeInst(param)[1].symbol.getImpl
        let paramName=x[0].as_str()
        echo "paramname is : ", paramname
        parseExpr(self.toStrLit().strVal & ".set" & paramName & "(" & component.toStrLit().strVal & ")")
        """.format(map_name))
      # parseExpr("proc get*[T](map: $1): $2[T] = map[T.name()]".format(map_name, container_name)),
      # parseExpr("proc set*[T](map: $1, component: T): $2[T] = map[T.name()] = component".format(map_name, container_name))
      )



###Generates e.g. 
# type MyMap* = ref object of RootObj
#     my_PrintableComponent: ComponentList[PrintableComponent]
#     my_AppendingComponent: ComponentList[AppendingComponent]

# proc getPrintableComponent(self: MyMap): ComponentList[PrintableComponent] = self.my_PrintableComponent
# proc putPrintableComponent(self: MyMap, component: ComponentList[PrintableComponent]) = self.my_PrintableComponent = component 

# shorthand access
# template `[]` (self: MyMap, param: untyped): untyped = `get param`(self)
# template `[]=` (self: MyMap, param: untyped, value: untyped): untyped = `put param`(self, value)

# but when working with template types you should use these to resolve the name properly
# proc get[T](map: MyMap): ComponentList[T] = map[T.name()]
# proc set[T](map: MyMap, component: T): ComponentList[T] = map[T.name()] = component

macro generateGenericMap*(map_name: string, my_container: untyped, my_types: varargs[untyped]): untyped =
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

  statement_list.add(generateFacade(my_map_name, my_container_name))

  statement_list = statement_list.copy
  
  return statement_list


# generateGenericMap("MyMap", ComponentList, PrintableComponent, AppendingComponent)