class_name HurtBox
extends Area3D

func _init() -> void:
	collision_layer = 4
	collision_mask = 3


func _on_hit(hitbox: HitBox) -> void:
	print(hitbox)
	if hitbox == null:
		return
	
	# проверяем чтобы нас не бил свой хитбокс
	if hitbox.get_parent().name != owner.name:
		if owner.has_method("TakeDamage") != null:
			owner.call("TakeDamage", hitbox.damage)


func _on_area_entered(area: Area3D) -> void:
	if area in get_tree().get_nodes_in_group(&"HitBox"):
		_on_hit(area)
