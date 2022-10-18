class_name Hurtbox
extends Area2D

func _init():
	collision_layer = 0
	collision_mask = 2

func _ready():
	connect('area_entered', self, '_on_area_entered')

func _on_area_entered( hitbox: HitBox ):
	if hitbox == null:
		return

	owner.isReceivingDamage = true
