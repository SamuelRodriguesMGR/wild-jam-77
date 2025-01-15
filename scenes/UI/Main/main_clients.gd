extends Control


func _on_join_button_pressed() -> void:
	Global.role_server = "client"
	Global.host_ip     = "178.208.94.78"
	get_tree().change_scene_to_file("res://scenes/game.tscn")
