import component
import sugar


type
    PrintableComponent* = ref object of Component
        my_data*: string

generate_typeinfo(PrintableComponent, "PrintableComponent")