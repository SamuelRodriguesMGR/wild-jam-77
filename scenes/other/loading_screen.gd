class_name LoadingScreen 
extends CanvasLayer

signal transition_in_ended

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var back_ground: ColorRect = %BackGround

func start_transition() -> void:
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	transition_in_ended.emit()

func finish_transition() -> void:
	animation_player.play("fade_to_normal")
	await animation_player.animation_finished
	get_tree().paused = false
