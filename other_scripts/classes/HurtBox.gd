class_name HurtBox
extends Area3D

func _init() -> void:
	collision_layer = 4
	collision_mask = 3

func _ready() -> void:
	self.area_entered.connect(_on_hit)


func _on_hit(hitbox: HitBox) -> void:
	if hitbox == null:
		return
	
	# проверяем чтобы нас не бил свой хитбокс
	if hitbox.get_parent().name != owner.name:
		if owner.has_method("TakeDamage") != null:
			owner.call("TakeDamage", hitbox.damage)
