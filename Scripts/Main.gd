extends Node

func _ready():
	Global.loadStage(self, "stage1")
	
	# Loads the player one
	Global.loadPlayer1(self, "soma", Vector2(100,100))
	
	for _i in self.get_children():
		print(_i)
	
func _process(delta):
	$Camera2D.position = $Player1.position

