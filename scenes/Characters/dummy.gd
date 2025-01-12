extends CharacterBody3D

@onready var anim: AnimationPlayer = $AnimationPlayer
var change_anim: int = 0

func _process(_delta: float) -> void:
	if change_anim < 100:
		anim.play("still")
	elif change_anim > 100 and change_anim < 200:
		anim.play("punched")
	elif change_anim > 200:
		change_anim = 0
	change_anim += 1
