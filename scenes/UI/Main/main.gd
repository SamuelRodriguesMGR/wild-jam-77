extends Control


@onready var text_ip : TextEdit = get_node("%TextIP")

func _change_scene(role : String) -> void:
	Global.role_server = role
	Global.host_ip     = text_ip.text
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
# Host
func _on_host_button_pressed() -> void:
	_change_scene("host")

# Client
func _on_join_button_pressed() -> void:
	_change_scene("client")
