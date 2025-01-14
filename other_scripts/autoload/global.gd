extends Node

var role_server : String
var host_ip     : String

func _ready() -> void:
	Engine.max_fps = 200
	
	if OS.has_feature("dedicated_server"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	
