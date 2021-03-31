

import ../ecslib/world
import ../ecslib/types

import ../ecslib/entity_tree
import options

var my_world: World = getWorld()
var parent_entity = my_world.globalEntity

for x in 0..10: 
    let child_entity = my_world.createEntity()
    let childB_entity = my_world.createEntity()
    let childC_entity = my_world.createEntity()
    echo "child entity to add: ", child_entity

    my_world.addChild(parent_entity, child_entity, "child")
    my_world.addChild(parent_entity, childB_entity, "childB")
    my_world.addChild(parent_entity, childB_entity, "childC")

    my_world.removeChild(parent_entity, "childC")
    parent_entity = child_entity

echo "retrieved child entity for 'child': ", my_world.getChild(my_world.globalEntity, "child")
echo "retrieved child entity for garbage: ", my_world.getChild(my_world.globalEntity, "")
echo "retrieved child entity from path /child", my_world.findEntity("/child")
echo "retrieved entity from path /child/child... ", my_world.findentity("/")
echo "retrieved entity from path /child/child... ", my_world.findentity("/child/child/child/child/child/child/child")
echo "retrieved entity from path /child/child... ", my_world.findentity("/child/child/child/child")
echo "retrieved entity from path /child/childB... ", my_world.findentity("/child/child/child/childB")
echo "retrieved entity from path /child/childC... none ", my_world.findentity("/child/child/child/childC")