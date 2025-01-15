class_name Potion
extends Resource

signal potion_is_used(potion: Potion)
signal potion_ended(potion: Potion)

enum potion_type {
	SPEED_POSITIVE, SPEED_NEGATIVE, 
	DAMAGE_POSITIVE, DAMAGE_NEGATIVE,
	POWER_POSITIVE, POWER_NEGATIVE,  
	COOLDOWN_POSITIVE, COOLDOWN_NEGATIVE,
	HEAL_POSITIVE, HEAL_NEGATIVE,
	POWER_SLASH, SLOW_SLASH,
	NULL}

@export var potion: potion_type
@export_range(1,3) var quality: int = 1
@export var icon: CompressedTexture2D = preload("res://assets/images/dummy.png")
var is_positive: bool

@export_category("Balance")
@export var is_percents: bool
@export var effect_amount: int
@export var time_to_use: int

var is_being_used: bool = false

func init() -> void:
	if(potion == potion_type.SPEED_POSITIVE or
	potion == potion_type.DAMAGE_POSITIVE or
	potion == potion_type.HEAL_POSITIVE or
	potion == potion_type.COOLDOWN_POSITIVE or
	potion == potion_type.POWER_SLASH or
	potion == potion_type.SLOW_SLASH or
	potion == potion_type.POWER_POSITIVE):
		is_positive = true
	else:
		is_positive = false
		

func _init() -> void:
	potion_is_used.connect(_on_potion_is_used)
	potion_ended.connect(_on_potion_ended)

func _on_potion_is_used(_potion: Potion):
	is_being_used = true

func _on_potion_ended(_potion: Potion):
	pass
