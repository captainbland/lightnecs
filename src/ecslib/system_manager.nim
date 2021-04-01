import my_system 
import sets
import tables
import intsets
import typetraits
import hashes
import types 



proc newSystemManager*(): SystemManager =
    SystemManager(signatures: initTable[SystemType, Signature](),
    systems: initTable[SystemType, MySystem]())

proc registerSystem*[T](self: SystemManager, sys: T): T =
    echo "registering system"
    let system_hash = hash(name(T))
    self.systems[system_hash] = sys
    return sys

proc setSignatureFromManager*[T](self: SystemManager, sys: T, signature: Signature): void =
    let system_hash = hash(name(T))
    self.signatures[system_hash] = signature 

proc entityDestroyed*(self: SystemManager, entity: Entity): void = 
    for hash, system in self.systems.pairs():
        system.entities.excl(entity)

proc entitySignatureChanged*(self: SystemManager, entity: Entity, entity_signature: Signature): void =

    for type_hash, system in self.systems.pairs():
        let system_signature = self.signatures[type_hash]
        #echo "system signature: ", self.signatures[type_hash]
        #echo "entity signature: ", entity_signature
        if self.signatures[type_hash].intersection(entity_signature) == system_signature:
            #echo "entity signature and including"
            echo "entity signature changed for ", system.name

            if not system.entities.containsOrIncl(entity):
                echo "contains or incl"
                system.onAddEntity(entity)
            
        else:
            system.entities.excl(entity)
