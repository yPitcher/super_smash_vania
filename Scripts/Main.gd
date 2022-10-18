extends Node

func _ready():
	Global.loadStage(self, "stage1")
	
	# Loads the players
	Global.loadPlayer(self, "soma", Vector2(300,60), 1)
	Global.loadPlayer(self, "julius", Vector2(600,60), 2)
	
	# Instantiate Camera2D Node
	#print(get_child(0).get_child(0))
	Global.loadCamera(self, "cameraByPlayer", 1, 1500, 1000, -1)
	

func _physics_process(delta):
	$Camera2D.position = $Player.position
