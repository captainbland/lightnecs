import ../ecslib/entity
import hashes

type
    SystemConcept* = concept system, entities
        run(system, entities) = void

    MySystem* = ref object of RootObj
        name*: string
        hash*: Hash

# proc run*[T: SystemConcept](system: T, entities: seq[Entity]): void = 
#     echo "I am not implemented!"

method run*(system: MySystem, entities: seq[Entity]): void = 
     echo "I am not implemented!"
     
const HASH = "MySystem".hash()
proc hash*(system: MySystem): Hash = HASH