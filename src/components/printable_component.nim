import ../ecslib/typeutil

import hashes

type
    PrintableComponent* = ref object of RootObj 
        my_data*: string

#generate_typeinfo(PrintableComponent)

proc type_hash*(c: PrintableComponent): Hash = hash($PRINTABLE_COMPONENT)