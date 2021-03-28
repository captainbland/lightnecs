import hashes
import sets
import types



# proc run*[T: SystemConcept](system: T, entities: seq[Entity]): void = 
#     echo "I am not implemented!"

method run*(system: MySystem, entities: seq[Entity]): void = 
     echo "I am not implemented!"

method onAddEntity*(system: MySystem, entity: Entity): void {.base.} = echo "I am not implemented"