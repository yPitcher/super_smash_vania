class_name CharacterBase extends KinematicBody2D

const UP 			= Vector2(0,-5)
const GRAVITY 		= 20
const SPEED 		= 300
const JUMP_HEIGHT 	= -400

enum stateMachine { IDLE, WALKING, JUMP, FALL }

var timer
var motion = Vector2()
var animation = ''
var direction = 0 #FALSE para direita & TRUE para esquerda
var state = stateMachine.IDLE
var enteredState = true
onready var animatedSprite : AnimatedSprite = get_node('AnimatedSprite')

func _physics_process(delta: float):
	motion = move_and_slide(motion, UP)
	direction = Input.get_axis('ui_left', 'ui_right')

func _move_and_slide():
  motion.x = direction * SPEED

func _apply_gravity():
  motion.y += GRAVITY

func _set_animation(anim: String):
	if animation != anim:
		animation = anim
		animatedSprite.play(animation)

func _stop_movement():
  motion.x = 0

func _set_flip():
	if direction:
		animatedSprite.flip_h = false if direction > 0 else true

func _enter_state(newState):
	if state != newState:
		state = newState
		enteredState = true
