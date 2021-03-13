import sdl2 as sdl
import sdl2/image as sdl_img
import typetraits
import tables
import options
import json

const SPRITESHEET_EXT = ".png"
const ANIM_EXT = ".json"

type
    SpriteManager* = ref object of RootObj
        sprites: Table[string, Sprite]
        animations: Table[string, AnimationInfo]
        directory: string
        renderer: RendererPtr

    Frame* = ref object of RootObj
        frame_width*: int
        frame_height*: int
        sheet_x*: int
        sheet_y*: int
        duration*: int
    
    AnimationInfo* = ref object of RootObj
        frames*: seq[Frame]

    Sprite* = ref object of RootObj
        handle*: string
        texture*: sdl.TexturePtr



proc newSpriteManager*(directory: string, renderer:RendererPtr): SpriteManager =
    SpriteManager(sprites: initTable[string, Sprite](), directory: directory, renderer: renderer)

proc getPath(directory, handle: string): string = directory & "/" & handle

proc loadSprite*(self: SpriteManager, handle: string): Sprite =
    echo "loading sprite from", getPath(self.directory, handle)
    let texture = sdl_img.loadTexture(self.renderer, getPath(self.directory, handle) & SPRITESHEET_EXT)
    echo "texture nil: ", texture == nil

    let my_sprite = Sprite(handle: handle, texture: texture)
    self.sprites[handle] = my_sprite
    return my_sprite

proc loadAnim*(self: SpriteManager, handle: string, animation_info: AnimationInfo): void =
    self.animations[handle] = animation_info

proc getSprite*(self: SpriteManager, handle: string): Option[Sprite] =
    return if self.sprites.hasKey(handle):
        some(self.sprites[handle])
    else:
        none(Sprite)

proc releaseSprite*(self: SpriteManager, handle: string): void =
    if self.sprites.hasKey(handle):
        destroy self.sprites[handle].texture
        self.sprites.del(handle)
        echo "deleted sprite"

proc loadAsepriteAnimation(filename: string): AnimationInfo =
    # super dangerous :D:D
    let raw_json = json.parseFile(filename)
    let frames = raw_json["frames"]
    var loaded_frames: seq[Frame] = @[]
    for frame in frames.items:
        let frame_data = frame["frame"]
        let this_frame = Frame(
            frame_width: frame_data["w"].getInt(),
            frame_height: frame_data["h"].getInt(),
            sheet_x: frame_data["x"].getInt(),
            sheet_y: frame_data["y"].getInt(),
            duration: frame["duration"].getInt()
        )
        loaded_frames.add(this_frame)
    
    return AnimationInfo(frames: loaded_frames)
    

proc loadAnimation*(self: SpriteManager, handle: string): AnimationInfo =
    self.animations[handle] = loadAsepriteAnimation(getPath(self.directory, handle) & ANIM_EXT)
    return self.animations[handle]