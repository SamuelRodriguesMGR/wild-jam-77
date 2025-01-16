class_name PotionSlots
extends Node

signal potion_slots_updated(potions: Array[Potion])

var null_potion: Potion = preload("res://godot_resources/potions/null_potion.tres")

var potions: Array[Potion]
#2 is min for size
var _slots_size: int = 3

func _init() -> void:
	if(_slots_size < 2):
		_slots_size = 2
	for i: int in _slots_size:
		potions.append(null_potion)

func _ready() -> void:
	potion_slots_updated.emit(potions)

##Example of use: portions_slots.put_potion_in(load("res://godot_resources/potions/coolown_potion_negative_2.tres"))
func put_potion_in(potion: Potion) -> void:
	for i: int in potions.size():
		if(potions[i] != null_potion):
			continue
		elif(i == potions.size()-1):
			potions[i] = potion
			break
		elif(potions[i] == null_potion):
			potions[i] = potion
			break
	potion_slots_updated.emit(potions)

func _put_potion_out()-> void:
	potions[0] = null_potion
	for i: int in potions.size()-1:
		var potion_tmp: Potion = potions[i]
		potions[i] = potions[i+1]
		potions[i+1] = potion_tmp
	potion_slots_updated.emit(potions)

func drink_potion() -> void:
	for i: int in potions.size():
		if(potions[i] == null_potion):
			continue
		else:
			potions[i].potion_is_used.emit(potions[i])
			_put_potion_out()
			break
