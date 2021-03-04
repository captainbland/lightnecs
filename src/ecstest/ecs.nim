import ../components/printable_component
import ../ecslib/component
import ../systems/printing_system 
import ../ecslib/entity
import ../ecslib/world
import tables





var my_entity = newEntity()
discard my_entity.addComponent(PrintableComponent(my_data: "this is mine!"))

var my_world = newWorld()
my_world = my_world.registerSystem(PrintingSystem(), "PrintableComponent".ComponentType)
discard my_world.addEntity(my_entity)

my_world.runSystems()

# let some_component: Component = PrintableComponent(my_data: "hi")
# PrintingSystem().run(some_component)

# echo string(some_component.typename)