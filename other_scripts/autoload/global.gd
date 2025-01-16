extends Node

var role_server : String
var host_ip     : String

func _ready() -> void:
	Engine.max_fps = 200
	
	if OS.has_feature("dedicated_server"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	


#Gameplay 
var is_early_game: bool = true:
	set(value):
		if(value == true):
			is_early_game = true
			is_mid_game = false
			is_late_game = false
	get():
		return is_early_game
var is_mid_game: bool:
	set(value):
		if(value == true):
			is_early_game = false
			is_mid_game = true
			is_late_game = false
	get():
		return is_mid_game
var is_late_game: bool:
	set(value):
		if(value == true):
			is_early_game = false
			is_mid_game = false
			is_late_game = true
	get():
		return is_late_game
