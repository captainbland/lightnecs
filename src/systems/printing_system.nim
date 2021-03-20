import system
import hashes
import sets

import ../components/printable_component
import ../ecslib/my_system
import ../ecslib/world
import ../ecslib/optionsutils
import sugar

type
    PrintingSystem* = ref object of MySystem

proc run*(self: PrintingSystem, my_world: World) =
    #echo "trying to run printing system"
    

    for entity in self.entities:
        #echo "processing entity", entity
        # applyWith(queryComponent[PrintableComponent](my_world, entity), 
        #     proc(printable: PrintableComponent) = discard) #echo printable.my_data)
        # .orElse(() => echo "could not get all required entities for PrintingSystem")
        let component = getComponent[PrintableComponent](my_world, entity)
        #echo PrintableComponent(component).my_data

            

