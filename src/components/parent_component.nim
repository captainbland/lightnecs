import ../ecslib/ecs

type
    ParentComponent* = ref object of RootObj
        entity*: Entity