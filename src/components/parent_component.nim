import ../ecslib/entity

type
    ParentComponent* = ref object of RootObj
        entity*: Entity