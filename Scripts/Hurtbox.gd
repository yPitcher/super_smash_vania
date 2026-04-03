class_name Hurtbox
extends Area2D

func _ready():
	collision_layer = 0
	collision_mask  = 2
	connect('area_entered', self, '_on_area_entered')

func _on_area_entered(hitbox: HitBox):
	if hitbox == null or owner == null:
		return

	# Ignore the hit if already taking damage (invincibility frames)
	if owner.isReceivingDamage:
		return

	# Walk up the hitbox's parent chain to find which character owns it
	var attacker = hitbox.get_parent()
	while attacker != null and not (attacker is KinematicBody2D):
		attacker = attacker.get_parent()

	# Ignore self-hits
	if attacker == null or attacker == owner:
		return

	owner.take_damage(hitbox.damage)
