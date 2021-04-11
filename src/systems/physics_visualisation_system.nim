import sys_sugar
import ../components/physics_components
import ../components/position_component
import ../ecslib/ecs
import ../chipmunk/chipmunk
import sets
import glm
import sdl2

type
    PhysicsVisualisationSystem* = ref object of MySystem

    
const null_vec = vec2d(-Inf, -Inf)



proc visualiseShape(shape: ShapePtr; data: pointer) {.cdecl.} =
    var renderer = cast[RendererPtr](data)
    let num_verts = getNumVerts(shape)
    var last_vert: Vector = null_vec
    for i in 0..num_verts-1:
        var this_vert = getVert(shape, i)
        if last_vert != null_vec:
            renderer.setDrawColor(0, 255, 0, SDL_ALPHA_OPAQUE)
            renderer.drawLine cint(last_vert.x), cint(last_vert.y), cint(this_vert.x), cint(this_vert.y)
        last_vert = this_vert

proc visualiseShape(body: BodyPtr, shape: ShapePtr; data: pointer) {.cdecl.} =
    var renderer = cast[RendererPtr](data)
    let num_verts = getNumVerts(shape)
    var last_vert: Vector = null_vec
    for i in 0..num_verts-1:
        var this_vert = getVert(shape, i)
        if last_vert != null_vec:
            renderer.setDrawColor(0, 255, 0, SDL_ALPHA_OPAQUE)
            renderer.drawLine cint(last_vert.x+body.getPos().x),
                 cint(last_vert.y+body.getPos().y),
                 cint(this_vert.x+body.getPos().x),
                 cint(this_vert.y+body.getPos().y)
        last_vert = this_vert


proc run*(self: PhysicsVisualisationSystem, renderer: RendererPtr) =
    let space_component = getComponent[SpaceComponent](self.world, self.world.globalEntity)
    # var static_shapes = (space_component.space.staticBody.shapeList)
    # var idx = 0
    # echo "space static body null? ", space_component.space.staticBody == nil
    # echo "space static body shapelist null? ", space_component.space.staticBody.shapeList == nil


    space_component.space.eachShape(visualiseShape, cast[pointer](renderer))

    for entity in self.entities:
        let body = getComponent[PhysicsBodyComponent](self.world, entity).body
        body.eachShape(visualiseShape, cast[pointer](renderer))