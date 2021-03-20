import ../components/printable_component
import ../components/appending_component
import macros

macro createGenericMap(): untyped =
    result = quote do: 
        type MyMap* = ref object of RootObj
            my_PrintableComponent: PrintableComponent
            my_AppendingComponent: AppendingComponent


    echo treeRepr result
            

createGenericMap()

echo "SPACE ==="
echo ""

dumpTree:
     type MyMap* = ref object of RootObj
            my_PrintableComponent: PrintableComponent
            my_AppendingComponent: AppendingComponent



proc getPrintableComponent(self: MyMap): PrintableComponent = self.my_PrintableComponent
proc putPrintableComponent(self: MyMap, component: PrintableComponent) =
    self.my_PrintableComponent = component


proc getAppendingComponent(self: MyMap): AppendingComponent = self.my_AppendingComponent
proc putAppendingComponent(self: MyMap, component: AppendingComponent) =
    self.my_AppendingComponent = component


#proc get[T](self: MyMap): T = discard

template `[]` (self: MyMap, param: untyped): untyped =
    `get param`(self)


template `[]=` (self: MyMap, param: untyped, value: untyped): untyped =
    `put param`(self, value)



var my_map = MyMap()

my_map[PrintableComponent] = PrintableComponent(my_data: "something")
echo my_map[PrintableComponent].my_data