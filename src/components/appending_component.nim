import ../ecslib/typeutil
import hashes
type
    AppendingComponent* = ref object of RootObj 
        to_append*: string

proc type_hash*(c: AppendingComponent): Hash = hash($APPENDING_COMPONENT)