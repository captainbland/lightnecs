import hashes

template generate_typeinfo*(my_type: untyped): untyped =
    let my_hash = hash($`my_type`)
    proc type_hash*[`my_type`](x: `my_type`): Hash = 
        return my_hash     
