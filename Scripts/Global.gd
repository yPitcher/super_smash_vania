extends Node

const players = {
	"soma": preload("res://Scenes/chars/Soma_Cruz.tscn"),
}

const stages = {
	"stage1": preload("res://Scenes/stages/stage1.tscn"),
}

const cameras = {
	"cameraByPlayer": preload("res://Scenes/cameras/CameraByChar.tscn"),
}

var player1 = null 

func _ready():
	pass
	
func loadPlayer1( context, character, pos):
	player1 = players[character].instance()
	player1.position = pos
	context.add_child( player1 )

func loadStage( context, character):
	var stage = stages[character].instance()

	context.add_child( stage )

func loadCamera(
		context,
		camera,
		limit_topsource = -10000000,
		limit_rightsource = 10000000,
		limit_bottomsource = 10000000,
		limit_leftsource = -10000000
	):
	var actualCamera = cameras[camera].instance()
	actualCamera.current = true
	
	actualCamera.limit_top = limit_topsource
	actualCamera.limit_right = limit_rightsource
	actualCamera.limit_bottom  = limit_bottomsource
	actualCamera.limit_left = limit_leftsource
	
	context.add_child( actualCamera )


