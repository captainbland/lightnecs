import ../ecslib/component
import hashes
type
    AppendingComponent* = ref object of Component
        to_append*: string

const APPENDING_COMPONENT_TYPE* = hash($APPENDING_COMPONENT).ComponentType


generate_typeinfo(AppendingComponent, APPENDING_COMPONENT_TYPE)