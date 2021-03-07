import component 
import my_system 
import entity 
import sets
import tables
import typeutil
import intsets

type
    SystemManager = ref object of RootObj 
        signatures: Table[SystemType, Signature]
        systems: Table[SystemType, MySystem]

proc registerSystem*[T](self: SystemManager): MySystem =
    let system_hash = type_hash[T]()
    var the_system = T()
    self.systems[system_hash] = the_system
    return the_system

proc setSignature*[T](self: SystemManager, signature: Signature): void =
    let system_hash = type_hash[T]()
    self.signatures[system_hash] = signature 

proc entityDestroyed(self: SystemManager, entity: Entity): void = 
    for hash, system in self.systems.pairs():
        system.entities.excl(entity)

proc entitySignatureChanged(self: SystemManager, entity: Entity, entity_signature: Signature): void =
    for type_hash, system in self.systems.pairs():
        let system_signature = self.signatures[type_hash]
        if self.signatures[type_hash].intersection(entity_signature) == system_signature:
            system.entities.incl(entity)
        else:
            system.entities.excl(entity)
