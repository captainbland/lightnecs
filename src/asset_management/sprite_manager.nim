import sdl2 as sdl
import sdl2/image as sdl_img
import typetraits
import tables
import options

type
    SpriteManager* = ref object of RootObj
        sprites: Table[string, Sprite]
        animations: Table[string, AnimationInfo]
        directory: string
        renderer: RendererPtr

    AnimationInfo* = ref object of RootObj
        frame_width: int
        frame_height: int
        sheet_width: int
        sheet_height: int
        ms_per_frame: int

    Sprite* = ref object of RootObj
        handle*: string
        texture*: sdl.TexturePtr



proc newSpriteManager*(directory: string, renderer:RendererPtr): SpriteManager =
    SpriteManager(sprites: initTable[string, Sprite](), directory: directory, renderer: renderer)

proc getPath(directory, handle: string): string = directory & "/" & handle

proc loadSprite*(self: SpriteManager, handle: string): Sprite =
    echo "loading sprite from", getPath(self.directory, handle)
    let texture = sdl_img.loadTexture(self.renderer, getPath(self.directory, handle))
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