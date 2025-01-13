extends Node

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene = preload("res://scenes/Characters/character.tscn")
@export var level_scene : PackedScene = preload("res://scenes/level.tscn")

var host_ip: String = "localhost"
#const host_ip: String = "178.208.94.78"
const PORT: int = 135

func _ready() -> void:
	
	if OS.has_feature("dedicated_server"):
		_run_server()
	else:
		definition_the_role()
		
# выбор роли
func definition_the_role() -> void:
	if GlobalVars.role_server == "host":
		_run_server()
		
	elif GlobalVars.role_server == "client":
		host_ip = GlobalVars.host_ip
		_run_client()
	
# хост 
func _run_server() -> void:
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_del_player)
	_add_level()
	_add_player()

# клиент
func _run_client() -> void:
	peer.create_client(host_ip, PORT)
	multiplayer.multiplayer_peer = peer

# добавление игрока
func _add_player(id : int = 1) -> void:
	var new_player : CharacterBody3D = player_scene.instantiate()
	new_player.name = str(id)
	print("+ conn ", new_player.name)
	get_tree().current_scene.call_deferred("add_child", new_player)
	
# добавление уровня
func _add_level() -> void:
	var level: Node3D = level_scene.instantiate()
	get_tree().current_scene.call_deferred("add_child", level)
	
# удаление игрока
func _del_player(id: int) -> void:
	var node: String = str(id)
	print("- disconn ", node)
	get_tree().current_scene.get_node(node).queue_free()
