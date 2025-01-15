class_name PotionSlots
extends Node

signal potion_slots_updated(potions: Array[Potion])

var null_potion: Potion = preload("res://godot_resources/potions/null_potion.tres")

var potions: Array[Potion]
#2 is min for size
var _slots_size: int = 3
var pointer_on_last_potion: int = 0

func _init() -> void:
	if(_slots_size < 2):
		_slots_size = 2
	for i: int in _slots_size:
		potions.append(null_potion)

func _ready() -> void:
	potion_slots_updated.emit(potions)

func put_potion_in(potion: Potion) -> void:
	var duplicated_potion: Potion = potion.duplicate(false)
	if(potions.size() == pointer_on_last_potion):
		potions[_slots_size-1] = duplicated_potion
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
	var is_drinked: bool = false
	for i: int in potions.size():
		if(is_drinked):
			break
		if(potions[i].potion == Potion.potion_type.NULL):
			continue
		else:
			_put_potion_out()
			potions[i].potion_is_used.emit(potions[i])
			potions[i].is_being_used = true
