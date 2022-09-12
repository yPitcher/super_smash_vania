extends Node2D

func _process(delta):
	$Camera2D.position = $Player1.position
	print($Scene/Area2D.get_overlapping_areas())
