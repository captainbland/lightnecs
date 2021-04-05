import sprite_manager
import sdl2 as sdl
import json
import tables
import sequtils
import strutils
import print

const JSON_EXT = ".json"

type

    TileSet* = ref object of RootObj
        sprite: Sprite
        tileWidth: int
        tileHeight: int
        tileCount: int
        spacing: int
        columns: int
    
    TileSetMapping* = ref object of RootObj
        firstId: int
        tileset: TileSet

    TileMapLayer = ref object of RootObj
        width: int
        height: int
        data: seq[int]

    TileMap = ref object of RootObj
        layers*: seq[TileMapLayer]
        tileSets*: seq[TileSetMapping]

    TileMapManager = ref object of RootObj
        directory: string
        spriteManager: SpriteManager
        tileSets*: Table[string, TileSet]
        tileMaps*: Table[string, TileMap]

proc newTileMapManager*(directory: string, renderer: RendererPtr): TileMapManager = 

    return TileMapManager(directory: directory,
    spriteManager: newSpriteManager(directory, renderer),
    tileSets: initTable[string, TileSet](),
    tileMaps: initTable[string, TileMap]())

proc fileNameToHandle(handle: string, ext: string): string =
    return handle.split(ext)[0]

proc loadTileset*(self: TileMapManager, handle: string): TileSet = 
    

    let raw_json = json.parseFile(getPath(self.directory, handle) & JSON_EXT)
    let cols = raw_json["columns"].getInt
    let tileWidth = raw_json["tilewidth"].getInt
    let tileHeight = raw_json["tileheight"].getInt
    let tileCount = raw_json["tilecount"].getInt
    let spacing = raw_json["spacing"].getInt
    let img_handle = raw_json["image"].getStr().fileNameToHandle(".png")
    let sprite = self.spriteManager.getOrLoadSprite(img_handle)

    let tileSet = TileSet(columns: cols,
        tileWidth: tileWidth,
        tileHeight: tileHeight,
        tileCount: tileCount,
        spacing: spacing,
        sprite: sprite
    )

    self.tileSets[handle] = tileSet
    return tileSet

proc getOrLoadTileset*(self: TileMapManager, handle: string): TileSet =
    if self.tileSets.hasKey(handle):
        return self.tileSets[handle]
    else:
        return loadTileset(self, handle)

#loads all of the tilemap's dependencies as well
proc loadTilemap*(self: TileMapManager, handle: string): TileMap =
    let raw_json = json.parseFile(getPath(self.directory, handle) & JSON_EXT)
    print raw_json
    let json_layers = raw_json["layers"]
    var layers: seq[TileMapLayer] = @[]
    for layer in json_layers.elems:
        var data: seq[int] = @[]
        for dataElem in layer["data"]:
            data.add(dataElem.getInt())

        let tileMapLayer = TileMapLayer(
            data: data,
            width: layer["width"].getInt(),
            height: layer["height"].getInt()
        )
        layers.add(tileMapLayer)
    
    var tilesets: seq[TileSetMapping] = @[]
    var json_tilesets = raw_json["tilesets"]

    for json_tileset in json_tilesets.elems:
        let tileset = getOrLoadTileset(self, json_tileset["source"].getStr().fileNameToHandle(JSON_EXT))

        tilesets.add(TileSetMapping(
            firstId: json_tileset["firstgid"].getInt(),
            tileset: tileset
        ))
    
    return TileMap(
        layers: layers,
        tilesets: tilesets
    )
