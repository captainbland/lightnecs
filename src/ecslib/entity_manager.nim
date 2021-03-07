import entity
import component
import deques

type 
    EntityManager* = ref object of RootObj
         signatures: array[MAX_ENTITIES, Signature]
         next_id_queue: Deque[Entity]

proc newEntityManager*(): EntityManager =
    var my_deque = initDeque[Entity]()
    for x in 0..MAX_ENTITIES:
        my_deque.addLast(Entity(x))

    EntityManager(next_id_queue: my_deque)        

proc newEntity*(self: var EntityManager): Entity =
    self.next_id_queue.popFirst()

proc setSignature*(self: EntityManager, entity: Entity, signature: Signature): void =
    self.signatures[entity] = signature

proc getSignature*(self: EntityManager, entity: Entity): Signature =
    self.signatures[entity]

proc destroyEntity*(self: EntityManager, entity: Entity): Signature =
    self.signatures[entity] = Signature()
    self.next_id_queue.addLast(entity)