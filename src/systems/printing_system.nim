import system
import hashes

import ../components/printable_component
import ../ecslib/component
import ../ecslib/my_system
import ../ecslib/entity

type
    PrintingSystem* = ref object of MySystem

method run*(self: PrintingSystem, entities: seq[Entity]) =
    #echo "trying to run printing system"
    
    for entity in entities:
        for component in entity.getComponents(PRINTABLE_COMPONENT_TYPE)[]:
                discard
                #echo PrintableComponent(component).my_data
            

const HASH = "PrintingSystem".hash()
proc hash*(system: PrintingSystem): Hash = HASH