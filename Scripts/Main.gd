extends Node

func _ready():
	Global.loadStage(self, "stage1")
	
	# Loads the players
	Global.loadPlayer(self, "soma", Vector2(300,60), 1)
	Global.loadPlayer(self, "julius", Vector2(800,60), 2)
	
	# Instantiate Camera2D Node
	Global.loadCamera(self, "cameraByPlayer", 1, 1500, 1000, -1)
	

func _physics_process(_delta: float):
	$Camera2D.position = $Player.position
