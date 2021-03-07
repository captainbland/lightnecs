import ../ecslib/component_list
import ../ecslib/entity
import ../ecslib/component
import ../ecslib/entity_manager
import ../components/printable_component
import ../components/appending_component
import options

var my_entity_manager = newEntityManager()

let my_entity = my_entity_manager.newEntity()
getComponentList[PrintableComponent]().addEntityComponent(my_entity, PrintableComponent(my_data: "sooo generic!"))
let myComponent: PrintableComponent = getComponentList[PrintableComponent]().getComponentFromList(my_entity)


echo myComponent.my_data

let my_entity_2 = my_entity_manager.newEntity()
getComponentList[PrintableComponent]().addEntityComponent(my_entity, PrintableComponent(my_data: "new entity component!"))
getComponentList[AppendingComponent]().addEntityComponent(my_entity, AppendingComponent(to_append: "we could append this!"))

let secondComponent = getComponentList[PrintableComponent]().getComponentFromList(my_entity)
let my_appending_component = getComponentList[AppendingComponent]().getComponentFromList(my_entity)
echo secondComponent.my_data
echo my_appending_component.to_append

