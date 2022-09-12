extends KinematicBody2D

const UP 			= Vector2(0,-1)
const GRAVITY 		= 30
const SPEED 		= 200
const JUMP_HEIGHT 	= -650

var timer
var sequence = []
const moves = {
	"hadouken"  : ["down", "front", "punch"],
	"shoryuken" : ["front", "down", "front", "punch"],
}

var motion = Vector2()

func _ready():
	$AnimatedSprite.flip_h = false
	self._config_timer()

func _config_timer():
	timer = Timer.new()
	add_child(timer)
	
	timer.wait_time = 0.5 # Wait time in seconds
	timer.one_shot = true # Run timer just one time
	
	timer.connect("timeout", self, "on_timeout")

func on_timeout():
	# verify special sequence
	#print(sequence)
	self._check_sequence(sequence)
	
	# Clean the sequence
	sequence = []

func _add_input_to_sequence( action ):
	sequence.push_back( action )

func _check_sequence(sequence):
	print(sequence)
	for move_name in moves.keys():
		if sequence == moves[move_name]:
			_play_action( move_name )

func _play_action(action):
	#print(sequence)
	pass

func _input(event):
	
	if(not event is InputEventKey):
		return
	if(not event.is_pressed()):
		return
		
	timer.start()
	
	if Input.is_action_pressed("ui_up"):
		_add_input_to_sequence("jump")
	elif Input.is_action_pressed("ui_left"):
		_add_input_to_sequence("walk_left")
	elif Input.is_action_pressed("ui_right"):
		_add_input_to_sequence("walk_right")
	elif Input.is_action_just_pressed("ui_basic_atack"):
		_add_input_to_sequence("basic_atack")

func _physics_process(delta):
	
	motion.y += GRAVITY
	
	if motion.y < 0 && !is_on_floor():
		$AnimatedSprite.play('jump')
	elif is_on_floor():
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		elif Input.is_action_pressed("ui_left"):
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play('walking')
			motion.x = -SPEED
		elif Input.is_action_pressed("ui_right"):
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play('walking')
			motion.x = SPEED
		elif Input.is_action_pressed("ui_ultimate"):
			$AnimatedSprite.play('ultimate')
		elif Input.is_action_just_pressed("ui_basic_atack"):
			$AnimatedSprite.play('basic_atack')
		else:
			$AnimatedSprite.play('idle')
			motion.x = 0
			
	motion = move_and_slide(motion, UP)
	
