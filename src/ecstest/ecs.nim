#import nimprof


import ../components/printable_component
import ../ecslib/component
import ../systems/printing_system 
import ../components/appending_component 
import ../systems/appending_system

import ../ecslib/my_system 

import ../ecslib/entity
import ../ecslib/world
import tables

var my_world: World = getWorld()
echo my_world.am_world

let my_printing_system = my_world.registerSystem(PrintingSystem())
my_world.setSystemSignature(my_printing_system, newSignature(getComponentType[PrintableComponent](my_world)))

let my_appending_system = my_world.registerSystem(AppendingSystem())
my_world.setSystemSignature(my_appending_system, newSignature(getComponentType[AppendingComponent](my_world), getComponentType[PrintableComponent](my_world)))

let my_entity = my_world.createEntity()


echo "my entity", my_entity
var my_printable_component = PrintableComponent(my_data: "i am a printable component")
var my_appending_component = AppendingComponent(to_append: ": let's append this")
my_world.addComponent(my_entity, my_printable_component)
my_world.addComponent(my_entity, my_appending_component)



proc mytest() =
    for x in 0..1000:
        my_appending_system.run(my_world)
        my_printing_system.run(my_world)
    
proc createComponentsTest() =
  for x in 0..9000:
    let my_entity = my_world.createEntity()
    var my_printable_component = PrintableComponent(my_data: "i am a printable component")
    var my_appending_component = AppendingComponent(to_append: ": let's append this")
    my_world.addComponent(my_entity, my_printable_component)
    my_world.addComponent(my_entity, my_appending_component)

    #my_world.destroyEntity(my_entity)

import times, os, strutils

template benchmark(benchmarkName: string, code: untyped) =
  block:
    let t0 = epochTime()
    code
    let elapsed = epochTime() - t0
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
    echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"


benchmark("thing", mytest())

benchmark("create components!", createComponentsTest())

#echo my_world.serialise()

# # let some_component: Component = PrintableComponent(my_data: "hi")
# # PrintingSystem().run(some_component)

# # echo string(some_component.typename)