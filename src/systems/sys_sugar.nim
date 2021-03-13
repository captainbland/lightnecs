template query*(my_type: untyped): untyped =
    queryComponent[my_type](my_world, entity)

template queryRelated*(my_type: untyped, the_entity: untyped): untyped =
    queryComponent[my_type](my_world, the_entity)

