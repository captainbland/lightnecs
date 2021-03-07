import ../ecslib/entity
import hashes
import typeutil
import sets

type
    SystemConcept* = concept system, entities
        run(system, entities) = void

    MySystem* = ref object of RootObj
        name*: string
        hash*: Hash
        entities*: HashSet[Entity]
    
    SystemType* = Hash

# proc run*[T: SystemConcept](system: T, entities: seq[Entity]): void = 
#     echo "I am not implemented!"

method run*(system: MySystem, entities: seq[Entity]): void = 
     echo "I am not implemented!"

generate_typeinfo(MySystem)
