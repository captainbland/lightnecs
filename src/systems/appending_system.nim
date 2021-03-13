import system
import hashes
import sets
import sugar 
import ../components/printable_component
import ../components/appending_component

import ../ecslib/ecs
import ../ecslib/optionsutils

type
    AppendingSystem* = ref object of MySystem

method run*(self: AppendingSystem, my_world: World) =
    #echo "trying to run printing system"
    
    for entity in self.entities:
        # var printable_component = getComponent[PrintableComponent](my_world, entity)
        # var appending_component = getComponent[AppendingComponent](my_world, entity)
        # #printable_component.my_data &= appending_component.to_append

        for entity in self.entities:
            applyWithAll(queryComponent[PrintableComponent](my_world, entity),
                         queryComponent[AppendingComponent](my_world, entity),
                proc(printable: PrintableComponent, appending: AppendingComponent) = printable.my_data &= appending.to_append)
                .orElse(() => echo "could not get all components in printing system")

