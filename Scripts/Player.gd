extends CharacterBase

func _process(delta):
	match state:
		stateMachine.IDLE: _state_idle()
		stateMachine.WALKING: _state_walk()
		stateMachine.JUMP: _state_jump()
		stateMachine.FALL: _state_fall()


func _state_idle():
	_set_animation('idle')
	_apply_gravity()
	_set_flip()

	if direction:
		_enter_state(stateMachine.WALKING)

	if Input.is_action_just_pressed('ui_up') && is_on_floor():
		_enter_state(stateMachine.JUMP)

func _state_walk():
	_set_animation('walking')
	_apply_gravity()
	_move_and_slide()
	_set_flip()

	if !direction:
		_enter_state(stateMachine.IDLE)

	if Input.is_action_just_pressed('ui_up') && is_on_floor():
		_enter_state(stateMachine.JUMP)

func _state_jump():
	_set_animation('jump')
	_apply_gravity()
	if enteredState:
		enteredState = false
		motion.y = JUMP_HEIGHT
	if motion.y > 0 :
		_enter_state(stateMachine.FALL)

func _state_fall():
	_set_animation('fall')
	_apply_gravity()

	if is_on_floor():
		_enter_state(stateMachine.IDLE)
