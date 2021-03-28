import sys_sugar
import ../components/physics_components.nim 

type
    PhysicsSystem* = ref object of MySystem

var chan: Channel[Option[PrintableComponent]]
var thread_killer: Channel[bool]
var my_thread: Thread[void]

method onAddEntity*(system: PhysicsSystem, entity: Entity): void = 
    getComponent[PhysicsShape]()

proc run(self: PhysicsSystem, dt float) =
    discard