import system
import hashes
import sets
import sdl2

import ../ecslib/ecs

import ../components/player_input_component
import ../components/position_component
import glm 
type
    PlayerInputSystem* = ref object of MySystem


func toInput(key: Scancode): Input =
  case key
  of SDL_SCANCODE_UP: Input.Up
  of SDL_SCANCODE_DOWN: Input.Down
  of SDL_SCANCODE_LEFT: Input.Left
  of SDL_SCANCODE_RIGHT: Input.Right
  else: Input.None

proc on_poll*(self: PlayerInputSystem, my_world: World, event: ptr Event) =
    #echo "trying to run printing system"
    
    for entity in self.entities:
        let input = getComponent[PlayerInputComponent](my_world, entity)
        case event[].kind:
            of KeyDown:
                input.inputs[event[].key.keysym.scancode.toInput] = true
            of KeyUp:
                input.inputs[event[].key.keysym.scancode.toInput] = false
            else: discard
        
            
proc on_update*(self: PlayerInputSystem, my_world: World, dt: float) = 
    for entity in self.entities:
        let input = getComponent[PlayerInputComponent](my_world, entity)
        let position = getComponent[RelativePositionComponent](my_world, entity)

        if input.inputs[Input.Up]:
            position.pos.y -= 2
        if input.inputs[Input.Down]:
            position.pos.y += 2
        if input.inputs[Input.Right]:
            position.pos.x += 2 
        if input.inputs[Input.Left]:
            position.pos.x -= 2