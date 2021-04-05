import ../asset_management/tilemap_manager
import sdl2
import sets
import ../ecslib/ecs
import sequtils
import sugar
import print
type
    TilemapSystem* = ref object of MySystem

    #intermediary type for tile processing
    SourceMapping = ref object of RootObj
        tileset*: TileSet
        sourceRect*: sdl2.Rect

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