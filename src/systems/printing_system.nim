import system
import hashes

import ../components/printable_component
import ../ecslib/component
import ../ecslib/my_system

type
    PrintingSystem* = ref object of MySystem

method run*(self: PrintingSystem, component: Component) =
    echo PrintableComponent(component).my_data

proc hash*(system: PrintingSystem): Hash = "PrintingSystem".hash()