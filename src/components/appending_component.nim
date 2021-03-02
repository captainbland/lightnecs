import component

type
    AppendingComponent* = ref object of Component
        to_append*: string

generate_typeinfo(AppendingComponent, "AppendingComponent")