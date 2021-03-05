import system
import hashes

import ../components/printable_component
import ../components/appending_component

import ../ecslib/component
import ../ecslib/my_system
import ../ecslib/entity

type
    AppendingSystem* = ref object of MySystem

method run*(self: AppendingSystem, entities: seq[Entity]) =
    for entity in entities:
        let printable_component = entity.getComponents(PRINTABLE_COMPONENT_TYPE)[0]

        for appending_component in entity.getComponents(APPENDING_COMPONENT_TYPE)[]:
            PrintableComponent(printable_component).my_data &= AppendingComponent(appending_component).to_append

const HASH = "AppendingSystem".hash()
proc hash*(system: AppendingSystem): Hash = HASH