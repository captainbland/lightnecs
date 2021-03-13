import system
import hashes
import sets

import ../components/printable_component
import ../ecslib/ecs
import ../ecslib/optionsutils
import sugar
type
    PrintingSystem* = ref object of MySystem

proc run*(self: PrintingSystem, my_world: World) =
    #echo "trying to run printing system"
    
    for entity in self.entities:
        applyWith(queryComponent[PrintableComponent](my_world, entity), 
            proc(printable: PrintableComponent) = discard printable.my_data)
        .orElse(() => echo "could not get all required entities for PrintingSystem")

