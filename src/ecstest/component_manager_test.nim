import ../ecslib/component_manager
import ../ecslib/entity
import ../ecslib/component
import ../ecslib/entity_manager
import ../components/printable_component
import ../components/appending_component
import options

var my_entity_manager = newEntityManager()

let my_entity = my_entity_manager.newEntity()
getComponentManager[PrintableComponent]().addEntityComponent(my_entity, PrintableComponent(my_data: "sooo generic!"))
let myComponent: PrintableComponent = getComponentManager[PrintableComponent]().getComponent(my_entity)


echo myComponent.my_data

let my_entity_2 = my_entity_manager.newEntity()
getComponentManager[PrintableComponent]().addEntityComponent(my_entity, PrintableComponent(my_data: "new entity component!"))
getComponentManager[AppendingComponent]().addEntityComponent(my_entity, AppendingComponent(to_append: "we could append this!"))

let secondComponent = getComponentManager[PrintableComponent]().getComponent(my_entity)
let my_appending_component = getComponentManager[AppendingComponent]().getComponent(my_entity)
echo secondComponent.my_data
echo my_appending_component.to_append

