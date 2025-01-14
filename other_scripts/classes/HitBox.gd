class_name HitBox
extends Area3D
@export var damage: int = 10

func _init() -> void:
	collision_layer = 3
	collision_mask = 4
