import ../ecslib/component
import sugar
import hashes


type
    PrintableComponent* = ref object of Component
        my_data*: string

const PRINTABLE_COMPONENT_TYPE* = hash($PRINTABLE_COMPONENT).ComponentType

generate_typeinfo(PrintableComponent, PRINTABLE_COMPONENT_TYPE)

echo PrintableComponent