extends Node

func _ready():
	Global.loadStage(self, "stage1")
	
	# Loads the player one
	Global.loadPlayer1(self, "soma", Vector2(100,80))
	
	# Instantiate Camera2D Node
	print(get_child(0).get_child(0).)
	Global.loadCamera(self, "cameraByPlayer", 1)
	

func _physics_process(delta):
	$Camera2D.position = $Player1.position
