import ../asset_management/tilemap_manager
import sdl2
import sets
import ../ecslib/ecs
import sequtils
import sugar
import print
import ../components/physics_components
import ../chipmunk/chipmunk
import glm
type
    TilemapSystem* = ref object of MySystem

    #intermediary type for tile processing
    SourceMapping = ref object of RootObj
        tileset*: TileSet
        sourceRect*: sdl2.Rect

proc generateCollisionGeometry(tilemap: TileMap, space: SpacePtr): void = 
    var basic_shapes: seq[seq[Vec2d]] = @[
        @[],
        @[vec2d(0,0),  vec2d(0,32), vec2d(32,32), vec2d(32,0)], # square
        @[vec2d(0,32), vec2d(32,32), vec2d(32,0)], # 45 degree right triangle
        @[vec2d(32,32), vec2d(0,0), vec2d(0,32)], # 45 degree left triangle
        @[vec2d(0,32), vec2d(32,32), vec2d(32,16)], #  45/2 degree right triangle bottom
        @[vec2d(32,32), vec2d(0,16), vec2d(0,32)], # 45/2 degree left triangle bottom
        @[vec2d(0,16), vec2d(32,16), vec2d(32,0)], #  45/2 degree right triangle top
        @[vec2d(16,32), vec2d(0,0), vec2d(0,16)], # 45/2 degree left triangle top
    ]

    

    let collisions_layer:TileMapLayer = tilemap.layers.filter((l) => l.name == "collisions")[0]
    let firstId = tilemap.tileSets.filter((s) => s.tileset.handle == "collisiontiles")[0].firstId

    var current_index = 0
    for y in 0..collisions_layer.height-1:
        for x in 0..collisions_layer.width-1:

            let pos = vec2d(float64(x*tilemap.tileWidth), float64(y*tilemap.tileHeight))
            let shape_id = collisions_layer.data[current_index]-firstId


            if collisions_layer.data[current_index] == 0:
                current_index += 1

                continue
            else:
                echo "absolute id: ", collisions_layer.data[current_index], " shape id: ", shape_id, " firstId: ", firstId

            var this_shape:seq[Vec2d] = basic_shapes[shape_id+1].map((p) => p + pos)
            
            let shape = newPolyShape(space.staticBody, cint(len(this_shape)), addr this_shape[0], vec2d(0,0))
            shape.setFriction(1.0)
            discard space.addShape(shape)
            current_index += 1




method onAddEntity(self: TilemapSystem, entity: Entity): void =
    let tilemap = getComponent[TileMap](self.world, entity)
    let space = getComponent[SpaceComponent](self.world, entity)
    generateCollisionGeometry(tilemap, space.space)


proc generateSourceRects(tilemap: TileMap): seq[SourceMapping] =
    var gid = 0
    # echo "TILESETS: "
    # print tilemap.tileSets


    let totalTiles = tilemap.tileSets.map((s) => s.tileset.tileCount).foldl(a+b)



    var source_maps: seq[SourceMapping] = newSeq[SourceMapping](len=totalTiles+1) #fixme, should be total tiles but doesn't work?
    echo source_maps.len
    for tileset_mapping in tilemap.tileSets:
        let tileset = tileset_mapping.tileset
        gid = tileset_mapping.firstId
       #echo "tileset dimensions: ", int(tileset.imageWidth/tileset.tileWidth), " ", int(tileset.imageHeight/tileset.tileHeight)
        for x in 0..int(tileset.imageWidth/tileset.tileWidth)-1:
            for y in 0..int(tileset.imageHeight/tileset.tileHeight)-1:
               # echo "processing x y gid: ", x, " ", y, " ", gid
                let x = cint(x*tileset.tileWidth)
                let y = cint(y*tileset.tileHeight)
                let source_rect = sdl2.rect(x,y,cint(tileset.tileWidth),cint(tileset.tileHeight))
                source_maps[gid] = SourceMapping(
                    tileset: tileset, sourceRect: source_rect
                )
                gid += 1

    return source_maps


proc renderLayer(tilemap: TileMap, tilemapLayer: TileMapLayer, sourceMappings: seq[SourceMapping], renderer: RendererPtr): void =
    var data_pos = 0
    for y in 0..int(tilemapLayer.height)-1:
        for x in 0..int(tilemapLayer.width)-1:
            var dest_rect = sdl2.rect(cint(x*tilemap.tileWidth),cint(y*tilemap.tileHeight),cint(tilemap.tileWidth), cint(tilemap.tileHeight))
            #echo "getting source mapping at index: ", tilemapLayer.data[data_pos]
            if tilemapLayer.data[data_pos] > 0:
                let source_mapping:SourceMapping = sourceMappings[tilemapLayer.data[data_pos]]
                renderer.copy source_mapping.tileset.sprite.texture, addr source_mapping.sourceRect, addr dest_rect
            data_pos += 1


proc renderTilemap(tilemap: TileMap, renderer:RendererPtr): void =
    let source_mappings = generateSourceRects(tilemap)
    for layer in tilemap.layers: 
        renderLayer(tilemap, layer, source_mappings, renderer)

proc run*(self: TilemapSystem, renderer: RendererPtr): void =
    for entity in self.entities:
        let tilemap = getComponent[TileMap](self.world, entity)
        renderTilemap(tilemap, renderer)