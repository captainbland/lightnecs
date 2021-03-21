import ../ecslib/generic_map 
import ../components/[printable_component, appending_component, draw_rect_component]


createGenericMap("MyMap", AppendingComponent, PrintableComponent, DrawRectComponent)


var my_map = MyMap()

my_map[PrintableComponent] = PrintableComponent(my_data: "something")
echo my_map[PrintableComponent].my_data