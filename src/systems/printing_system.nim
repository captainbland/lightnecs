import system
import hashes
import sets

import ../components/printable_component
import ../ecslib/my_system
import ../ecslib/world
import ../ecslib/typeutil
type
    PrintingSystem* = ref object of MySystem

proc run*(self: PrintingSystem, my_world: World) =
    #echo "trying to run printing system"
    
    for entity in self.entities:
        let component = getComponent[PrintableComponent](my_world, entity)
        #echo PrintableComponent(component).my_data
            

proc type_hash*(c: PrintingSystem): Hash = hash($PRINTING_SYSTEM)