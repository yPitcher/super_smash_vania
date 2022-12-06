extends Node2D

func _on_Button2_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")



func _on_Button3_pressed():
	Server.connectToServer()
	get_tree().change_scene("res://Scenes/OnlineMain.tscn")
