import ../ecslib/component_manager
import ../ecslib/entity
import ../ecslib/component
import ../components/printable_component
import ../components/appending_component
import options


template componentDefinitions(x :untyped): untyped = 
    x(PrintableComponent)
    x(AppendingComponent)



template templateInit(com: untyped): untyped =
    discard getComponentManager[com]()

componentDefinitions(templateInit)

discard getComponentManager[PrintableComponent]()


let my_entity = newEntity()
getComponentManager[PrintableComponent]().addEntityComponent(my_entity, PrintableComponent(my_data: "sooo generic!"))
let myComponent: PrintableComponent = getComponentManager[PrintableComponent]().getComponent(my_entity)
echo myComponent.my_data