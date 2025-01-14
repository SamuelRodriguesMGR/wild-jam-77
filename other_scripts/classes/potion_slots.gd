class_name PotionSlots
extends Node

signal potion_slots_updated(potions: Array[Potion])

var null_potion: Potion = preload("res://godot_resources/potions/null_potion.tres")

var potions: Array[Potion]
var slots_size: int = 3
var pointer_on_last_potion: int = 0

func _init() -> void:
	##test
	potion_slots_updated.connect(_update_test)
	for i: int in slots_size:
		potions.append(null_potion)

##test
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("transform")):
		var rand: int = randi_range(0,4)
		if(rand == 0):
			put_potion_in((load("res://godot_resources/potions/power_potion_negative_2.tres") as Potion).duplicate(false))
		elif (rand == 1):
			put_potion_in((load("res://godot_resources/potions/speed_potion_negative_3.tres") as Potion).duplicate(false))
		elif (rand == 2):
			put_potion_in((load("res://godot_resources/potions/health_potion_negative_2.tres") as Potion).duplicate(false))
		elif (rand == 3):
			put_potion_in((load("res://godot_resources/potions/slow_slash_3.tres") as Potion).duplicate(false))
		elif (rand == 4):
			put_potion_in((load("res://godot_resources/potions/health_potion_positive_1.tres") as Potion).duplicate(false))
	if(Input.is_action_just_pressed("attack")):
		_put_potion_out()


func put_potion_in(potion: Potion) -> void:
	var duplicated_potion: Potion = potion.duplicate(false)
	if(potions.size() == pointer_on_last_potion):
		potions[slots_size-1] = duplicated_potion
	else:
		potions[pointer_on_last_potion] = duplicated_potion
		pointer_on_last_potion+=1
	potion_slots_updated.emit(potions)

func _put_potion_out()-> void:
	if(potions[0] != null_potion):
		pointer_on_last_potion-=1
		potions[0] = null_potion
		for i: int in potions.size():
			if(potions.size()-1 == i):
				potions[i] = null_potion
				break
			potions[i] = potions[i+1]
	potion_slots_updated.emit(potions)

func drink_potion() -> void:
	await get_tree().create_timer(potions[0].time_to_use)
	_put_potion_out()

func _update_test(portions: Array[Potion]) -> void:
	print(portions[0].potion, "|",portions[1].potion, "|",portions[2].potion)
