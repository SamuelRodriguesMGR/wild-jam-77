extends Node3D

var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene = preload("res://scenes/Characters/character.tscn")
@export var level_scene : PackedScene = preload("res://scenes/level.tscn")

const HOST_IP: String = "localhost"
#const HOST_IP: String = "178.208.94.78"
const PORT: int = 135

func _ready() -> void:
	if OS.has_feature("dedicated_server"):
		peer.create_server(PORT)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_add_player)
		multiplayer.peer_disconnected.connect(_del_player)
		_add_level()

func _on_connect_pressed() -> void:
	peer.create_client(HOST_IP, PORT)
	multiplayer.multiplayer_peer = peer
	
func _add_player(id: int = 1) -> void:
	var player: CharacterBody3D = player_scene.instantiate()
	player.name = str(id)
	print("+ conn ", player.name)
	call_deferred("add_child", player)

func _del_player(id: int) -> void:
	var node: String = str(id)
	print("- disconn ", node)
	get_node(node).queue_free()

func _add_level() -> void:
	var level: Node3D = level_scene.instantiate()
	call_deferred("add_child", level)
