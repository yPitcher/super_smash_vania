extends CharacterBase

func _process(delta):
	match state:
		stateMachine.IDLE: _state_idle()
		stateMachine.WALKING: _state_walk()
		stateMachine.JUMP: _state_jump()
		stateMachine.FALL: _state_fall()
		stateMachine.IDDLE_MIDDLE_FIST_ATTACK: _state_idle_middle_fist_attack()
		stateMachine.IDDLE_MIDDLE_LEG_ATTACK: _state_idle_middle_leg_attack()
		stateMachine.JUMP_LEG_ATTACK: _state_jump_leg_attack()



func _state_idle():
	_set_animation('idle')
	_apply_gravity()
	_set_flip()

	if direction:
		_enter_state(stateMachine.WALKING)
	elif Input.is_action_just_pressed('ui_up') && is_on_floor():
		_enter_state(stateMachine.JUMP)
	elif Input.is_action_just_pressed('ui_basic_fist_attack') && is_on_floor():
		_enter_state(stateMachine.IDDLE_MIDDLE_FIST_ATTACK)
	elif Input.is_action_just_pressed('ui_basic_leg_attack') && is_on_floor():
		_enter_state(stateMachine.IDDLE_MIDDLE_LEG_ATTACK)
		

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
	elif motion.y > 0 :
		_enter_state(stateMachine.FALL)
	elif Input.is_action_just_pressed('ui_basic_leg_attack') && !is_on_floor():
		_apply_gravity()
		_enter_state(stateMachine.JUMP_LEG_ATTACK)

func _state_fall():
	_set_animation('fall')
	_apply_gravity()

	if is_on_floor():
		_enter_state(stateMachine.IDLE)
		_stop_movement()

func _state_idle_middle_fist_attack():
	_stop_movement()
	_set_animation('idleMiddleFistAttack')
	
	if enteredState:
		enteredState = false
		yield(get_tree().create_timer(0.4), "timeout")
		_enter_state(stateMachine.IDLE)

func _state_idle_middle_leg_attack():
	_stop_movement()
	_set_animation('idleMiddleLegAttack')

	if enteredState:
		enteredState = false
		yield(get_tree().create_timer(0.3), "timeout")
		_enter_state(stateMachine.IDLE)

func _state_jump_leg_attack():
	_apply_gravity()
	_set_animation('jumpLegAttack')

	if enteredState:
		enteredState = false
		yield(get_tree().create_timer(0.4), "timeout")
		_stop_movement()
		_enter_state(stateMachine.IDLE)
