import ../ecslib/component
import sugar
import hashes

type
    PrintableComponent* = object
        my_data*: string

generate_typeinfo(PrintableComponent)
