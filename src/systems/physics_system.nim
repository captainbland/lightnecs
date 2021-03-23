type
    PhysicsSystem* = ref object of MySystem

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
