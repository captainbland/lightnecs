import system
import hashes
import sets

import ../components/printable_component
import ../ecslib/my_system
import ../ecslib/world
import ../ecslib/optionsutils
import ../ecslib/types
import sugar
import os
import options
import iterutils

type
    PrintingSystem* = ref object of MySystem

var chan: Channel[Option[PrintableComponent]]
var thread_killer: Channel[bool]
var my_thread: Thread[void]

proc threadWorker() {.thread.} =
    while true:
        os.sleep(16)
        let (received_end, end_me) = thread_killer.tryRecv()
        if received_end and end_me:
            echo "ending thread"
            return

        let(received, printable_components) = chan.tryRecv()
        if received:
            discard applyWith(printable_components, proc(printable: PrintableComponent) = discard)

proc startThread*(self: PrintingSystem) =
    chan.open()
    thread_killer.open()
    createThread(my_thread, threadWorker)

proc endThread*(self:PrintingSystem) = 
    thread_killer.send(true)
    joinThread(my_thread)
    chan.close()
    thread_killer.close()

method onAddEntity*(system: PrintingSystem, entity: Entity): void = 
    discard
    #echo "Printing system add entity ", entity

proc run*(self: PrintingSystem, my_world: World) =
    #echo "trying to run printing system"
    for entity in self.entities:
        chan.send(queryComponent[PrintableComponent](self.world, entity))

        # default runs in about 0.561s for 1000 entities, 10k iters

        #echo "processing entity", entity

        # applyWith(queryComponent[PrintableComponent](my_world, entity), 
        #     proc(printable: PrintableComponent) = echo printable.my_data) #echo printable.my_data)
        # .orElse(() => echo "could not get all required entities for PrintingSystem")

        #let component = getComponent[PrintableComponent](my_world, entity)
        #echo PrintableComponent(component).my_data

            

