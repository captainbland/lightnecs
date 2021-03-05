import nimprof


import ../components/printable_component
import ../ecslib/component
import ../systems/printing_system 
import ../components/appending_component 
import ../systems/appending_system

import ../ecslib/my_system 

import ../ecslib/entity
import ../ecslib/world
import tables


template my_world(): var World =
    var world = newWorld()

    for x in 0..2000:
        var my_entity = newEntity()
        discard my_entity.addComponent(PrintableComponent(my_data: "this is mine!")).addComponent(AppendingComponent(to_append: "this gets appended!"))

        discard world.registerSystem(AppendingSystem(name: "appending system"), APPENDING_COMPONENT_TYPE)
        .registerSystem(PrintingSystem(name: "printing system!"), PRINTABLE_COMPONENT_TYPE)
                        
        discard world.addEntity(my_entity)
    world

proc mytest(world: var World) =

    for x in 0..1:
        world.runSystems()
    
    #echo PrintableComponent(my_entity.getComponents($PRINTABLE_COMPONENT)[0]).my_data



import times, os, strutils

template benchmark(benchmarkName: string, code: untyped) =
  block:
    let t0 = epochTime()
    code
    let elapsed = epochTime() - t0
    let elapsedStr = elapsed.formatFloat(format = ffDecimal, precision = 3)
    echo "CPU Time [", benchmarkName, "] ", elapsedStr, "s"

var test_world = my_world()
benchmark("thing", mytest(test_world))

# let some_component: Component = PrintableComponent(my_data: "hi")
# PrintingSystem().run(some_component)

# echo string(some_component.typename)