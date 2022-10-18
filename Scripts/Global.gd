extends Node

const characters = {
	'soma': preload('res://Scenes/chars/Soma_Cruz.tscn'),
	'julius': preload('res://Scenes/chars/Julius_Belmont.tscn')
}

const stages = {
	'stage1': preload('res://Scenes/stages/stage1.tscn'),
}

const cameras = {
	'cameraByPlayer': preload('res://Scenes/cameras/CameraByChar.tscn'),
}

func _ready():
	pass
	
func loadPlayer( context, character, pos, playernum ):
	var player = characters[character].instance()
	player.position = pos
	context.add_child( player )
	if playernum != 1:
		player.animatedSprite.flip_h = true

func loadStaticEnemy( context, character, pos ):
	var enemy = characters[character].instance()
	enemy.position = pos
	enemy.isStaticEnemy = true
	context.add_child( enemy )
	enemy.animatedSprite.flip_h = true

func loadStage( context, stageName ):
	var stage = stages[stageName].instance()

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
