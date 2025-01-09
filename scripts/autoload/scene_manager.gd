extends Node

signal transition_finished

var loading_screen: LoadingScreen
var _loading_screen_scene:PackedScene = preload("res://scenes/other/loading_screen.tscn")
var _load_scene:PackedScene
var the_scene_path: String

func load_scene(scene_path:String) -> void:
	the_scene_path = scene_path
	_start_load_scene()
	
func _start_load_scene()-> void:
	if(loading_screen != null):
		return
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	if(!loading_screen.transition_in_ended.is_connected(_on_transition_in_ended)):
		if loading_screen.transition_in_ended.connect(_on_transition_in_ended): printerr("Fail: ",get_path()) 
	
func _end_load_scene()-> void:
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_packed(_load_scene)
	transition_finished.emit()
	await loading_screen.finish_transition()
	get_tree().root.remove_child(loading_screen)
	loading_screen.queue_free()

func _on_transition_in_ended()->void:
	_load_scene = load(the_scene_path)
	_end_load_scene()
