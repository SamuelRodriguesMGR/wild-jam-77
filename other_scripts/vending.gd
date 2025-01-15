extends StaticBody3D
@onready var area: Area3D = $InteractionArea

var is_body_inside = false
var bodies: Array[Node3D]

func _init() -> void:
	collision_mask = 2
	
func _process(delta: float) -> void:
	bodies =  area.get_overlapping_bodies()
	if bodies != [] and Input.is_action_just_pressed("interact"):
		for body in bodies:
			print(body.gold)
			body.gold -= 1
			print(body.gold)
		print("bought")
