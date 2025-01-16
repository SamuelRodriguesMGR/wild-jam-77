extends Control


@onready var name_server : TextEdit = get_node("%TextEdit")

func _on_button_pressed() -> void:
	Global.role_server = "host"
	Global.host_ip     = "localhost"
	get_tree().change_scene_to_file("res://scenes/game.tscn")
