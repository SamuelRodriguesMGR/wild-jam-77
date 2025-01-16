class_name VendingUI
extends Node3D

@onready var vending_label_3d: Label3D = %VendingLabel3D

var text_to_roll_positive: String = " to roll positive "
var text_1st: String = " 1st "
var text_2nd: String = " 2nd "
var text_3d: String = " 3d "
var text_tier: String = " tier "
var text_positive_potion: String = " POSITIVE potion "
var text_to_spend: String = " to spend "
var text_gold_to_upgrade: String = " gold to upgrade "
var text_to_roll: String = " to roll "
var text_you_cannot_upgrade_further: String = " You cannot upgrade further! "

var demand_to_roll_string: String = "You cannot roll potion, \
spend at least 1 gold to roll POSITIVE potion with "
var text_chance: String = " chance!"

var key_string_to_spend: String = ""
var key_string_to_roll: String = ""

func _ready() -> void:
	key_string_to_spend = _get_first_key_string_for_action("spend_money_to_vending")
	key_string_to_roll = _get_first_key_string_for_action("roll_potion")

func update_state(chance: int, current_quality: int, _next_quality: int, money_cost: int) -> void:
	var style_chance: String = str(chance) + "%"
	var quality_str: String
	if(current_quality == 1):
		quality_str = text_1st
	elif(current_quality == 2):
		quality_str = text_2nd
	elif(current_quality == 3):
		quality_str = text_3d
	
	if (current_quality == 0):
		vending_label_3d.text = key_string_to_spend + demand_to_roll_string + style_chance + text_chance
	elif(current_quality > 0 and current_quality < 3):
		vending_label_3d.text = style_chance + text_to_roll_positive + quality_str + text_tier + text_positive_potion \
		+ "\n" + key_string_to_spend + text_to_spend + str(money_cost) + text_gold_to_upgrade + text_tier \
		+ "\n" + key_string_to_roll + text_to_roll
	elif(current_quality == 3):
		vending_label_3d.text = style_chance + text_to_roll_positive + quality_str + text_tier + text_positive_potion \
		+ "\n" + text_you_cannot_upgrade_further \
		+ "\n" + key_string_to_roll + text_to_roll
func _get_first_key_string_for_action(action_name: String) -> String:
	var actions: Array[StringName] = InputMap.get_actions()
	for i: StringName in actions:
		if(i == action_name):
			return "\"" + InputMap.action_get_events(i)[0].as_text()[0] + "\""
	return "Error InputMapping get_first_key_string_for_action"
