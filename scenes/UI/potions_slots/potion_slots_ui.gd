class_name PotionSlotsUI
extends AspectRatioContainer

var potion_slot_pck: PackedScene = preload("res://scenes/UI/potions_slots/potion_slot.tscn") as PackedScene

var _slots_textures: Array[PotionSlot]
@onready var _slots: VBoxContainer = %Slots

func _on_potion_slots_updated(potions: Array[Potion]) -> void:
	if(_slots_textures.size() != potions.size()):
		for i: Node in _slots.get_children():
			i.queue_free()
		for i: int in potions.size():
			var tmp_slot: PotionSlot = potion_slot_pck.instantiate()
			_slots.add_child(tmp_slot)
			tmp_slot.init_slot_with_potion(potions[i])
			(_slots.get_children()[0] as PotionSlot).size_flags_stretch_ratio = 1.5
		(_slots.get_children()[0] as PotionSlot).size_flags_stretch_ratio = 1.5
		(_slots.get_children()[1] as PotionSlot).size_flags_stretch_ratio = 1.0
	else:
		var i: int = 0
		for potion_slot: Node in _slots.get_children():
			if(potion_slot is not PotionSlot):
				printerr("Type error, _on_potion_slots_updated, potion_lots_ui.gd")
			else:
				(potion_slot as PotionSlot).init_slot_with_potion(potions[i])
				i+=1
		_swap_slots()

func _swap_slots() -> void:
	_slots.get_children()[0].move_child(_slots,1)
	(_slots.get_children()[1] as PotionSlot).size_flags_stretch_ratio = 1.5
	(_slots.get_children()[0] as PotionSlot).size_flags_stretch_ratio = 1.0
