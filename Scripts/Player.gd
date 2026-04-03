extends CharacterBase

func _process(_delta):
	match state:
		stateMachine.IDLE:                    _state_idle()
		stateMachine.WALKING:                 _state_walk()
		stateMachine.JUMP:                    _state_jump()
		stateMachine.FALL:                    _state_fall()
		stateMachine.IDLE_MIDDLE_FIST_ATTACK: _state_idle_middle_fist_attack()
		stateMachine.IDLE_MIDDLE_LEG_ATTACK:  _state_idle_middle_leg_attack()
		stateMachine.JUMP_LEG_ATTACK:         _state_jump_leg_attack()
		stateMachine.TAKE_DAMAGE:             _state_take_damage()


func _state_idle():
	_set_animation('idle')
	_apply_gravity()
	_set_flip()

	if isReceivingDamage:
		_enter_state(stateMachine.TAKE_DAMAGE)
	elif direction:
		_enter_state(stateMachine.WALKING)
	elif Input.is_action_just_pressed('ui_up') && is_on_floor():
		_enter_state(stateMachine.JUMP)
	elif Input.is_action_just_pressed('ui_basic_fist_attack') && is_on_floor():
		_enter_state(stateMachine.IDLE_MIDDLE_FIST_ATTACK)
	elif Input.is_action_just_pressed('ui_basic_leg_attack') && is_on_floor():
		_enter_state(stateMachine.IDLE_MIDDLE_LEG_ATTACK)

func _state_walk():
	_set_animation('walking')
	_apply_gravity()
	_move_and_slide()
	_set_flip()

	if isReceivingDamage:
		_enter_state(stateMachine.TAKE_DAMAGE)
	elif !direction:
		_enter_state(stateMachine.IDLE)
	elif Input.is_action_just_pressed('ui_up') && is_on_floor():
		_enter_state(stateMachine.JUMP)

func _state_jump():
	_set_animation('jump')
	_apply_gravity()

	if isReceivingDamage:
		_enter_state(stateMachine.TAKE_DAMAGE)
	elif enteredState:
		enteredState = false
		motion.y = JUMP_HEIGHT
	elif is_on_floor():
		_stop_movement()
		_enter_state(stateMachine.IDLE)
	elif motion.y > 0:
		_enter_state(stateMachine.FALL)
	elif Input.is_action_just_pressed('ui_basic_leg_attack') && !is_on_floor():
		_apply_gravity()
		_enter_state(stateMachine.JUMP_LEG_ATTACK)

func _state_fall():
	_set_animation('fall')
	_apply_gravity()

	if isReceivingDamage:
		_enter_state(stateMachine.TAKE_DAMAGE)
	elif Input.is_action_just_pressed('ui_basic_leg_attack'):
		_enter_state(stateMachine.JUMP_LEG_ATTACK)
	elif is_on_floor():
		_stop_movement()
		_enter_state(stateMachine.IDLE)

func _state_idle_middle_fist_attack():
	_stop_movement()
	_set_animation('idleMiddleFistAttack')

	if enteredState:
		enteredState = false
		_load_hitbox('middle')
		yield(get_tree().create_timer(0.4), "timeout")
		if not is_instance_valid(self):
			return
		_kill_hitbox('middle')
		if state == stateMachine.IDLE_MIDDLE_FIST_ATTACK:
			_enter_state(stateMachine.IDLE)

func _state_idle_middle_leg_attack():
	_stop_movement()
	_set_animation('idleMiddleLegAttack')

	if enteredState:
		enteredState = false
		_load_hitbox('middle')
		yield(get_tree().create_timer(0.3), "timeout")
		if not is_instance_valid(self):
			return
		_kill_hitbox('middle')
		if state == stateMachine.IDLE_MIDDLE_LEG_ATTACK:
			_enter_state(stateMachine.IDLE)

func _state_jump_leg_attack():
	_apply_gravity()
	_set_animation('jumpLegAttack')

	# Cancel attack the moment the character touches the ground
	if is_on_floor():
		_kill_hitbox('middle')
		_stop_movement()
		_enter_state(stateMachine.IDLE)
		return

	if enteredState:
		enteredState = false
		_load_hitbox('middle')
		yield(get_tree().create_timer(0.87), "timeout")
		if not is_instance_valid(self):
			return
		_kill_hitbox('middle')
		_stop_movement()
		if state == stateMachine.JUMP_LEG_ATTACK:
			_enter_state(stateMachine.IDLE)

func _state_take_damage():
	_apply_gravity()
	_set_animation('takeDamage')

	if enteredState:
		enteredState = false
		yield(get_tree().create_timer(0.5), "timeout")
		if not is_instance_valid(self):
			return
		isReceivingDamage = false
		if state == stateMachine.TAKE_DAMAGE:
			_enter_state(stateMachine.IDLE)
