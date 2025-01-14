extends Control

func _change_scene(role : String) -> void:
	GlobalVars.role_server = role
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
# Host
func _on_host_button_pressed() -> void:
	_change_scene("host")

# Client
func _on_join_button_pressed() -> void:
	_change_scene("client")
