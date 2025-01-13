extends Control


@onready var text_ip_host : TextEdit = get_node("%IpHost")

func _change_scene(role : String) -> void:
	GlobalVars.role_server = role
	
	if not text_ip_host.text:
		GlobalVars.host_ip = "localhost"
	else:
		GlobalVars.host_ip = text_ip_host.text
	
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
# Host
func _on_host_button_pressed() -> void:
	_change_scene("host")

# Client
func _on_join_button_pressed() -> void:
	_change_scene("client")
