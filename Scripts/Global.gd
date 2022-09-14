extends Node

const players = {
	"soma": preload("res://Scenes/chars/Soma_Cruz.tscn"),
}

const stages = {
	"stage1": preload("res://scenes/stages/stage1.tscn"),
}

var player1 = null 

func _ready():
	pass
	
func loadPlayer1( context, character, pos):
	player1 = players[character].instance()
	player1.position = pos
	context.add_child(player1)

func loadStage( context, character):
	var stage = stages[character].instance()

	context.add_child( stage )



