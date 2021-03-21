import ../ecslib/generic_map 
import ../ecslib/component_list
import ../components/[printable_component, appending_component, draw_rect_component]
import typetraits
import strutils

generateGenericMap("MyMap", ComponentList, AppendingComponent, PrintableComponent, DrawRectComponent)


var my_map = MyMap()


my_map[PrintableComponent] = ComponentList[PrintableComponent]()


proc accessGeneric[T](): void =
    discard my_map[T]

accessGeneric[PrintableComponent]()