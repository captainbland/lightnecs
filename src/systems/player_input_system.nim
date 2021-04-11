import system
import hashes
import sets
import sdl2

import ../ecslib/ecs

import ../components/player_input_component
import ../components/position_component
import ../components/physics_components
import ../components/jump_state
import ../chipmunk/chipmunk
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
        let physics_body = getComponent[PhysicsBodyComponent](my_world, entity).body
        let jump_state = getComponent[JumpStateComponent](my_world, entity)
        if input.inputs[Input.Up]:
            jump_state.jump_signal = JUMP
        if input.inputs[Input.Right]:
            if physics_body.getVel().x <= 100.0:
                physics_body.setVel(physics_body.getVel + vec2d(15,0))
                        #position.pos.x += 2 
        if input.inputs[Input.Left]:
            if physics_body.getVel().x >= -100.0:

                physics_body.setVel(physics_body.getVel + vec2d(-15,0))


            #position.pos.x -= 2
        
