import ../ecslib/component
import hashes
type
    AppendingComponent* = object 
        to_append*: string

generate_typeinfo(AppendingComponent)
