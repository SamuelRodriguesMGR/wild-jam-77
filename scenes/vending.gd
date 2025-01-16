class_name Vending
extends StaticBody3D

@export_category("balance_chances")
@export_group("Early game")
@export_range(0,100) var early_game_chance_quality_1: int = 70
@export_range(0,100) var early_game_chance_quality_2: int = 30
@export_range(0,100) var early_game_chance_quality_3: int = 0
@export_group("Mid Game")
@export_range(0,100) var mid_game_chance_quality_1: int = 50
@export_range(0,100) var mid_game_chance_quality_2: int = 40
@export_range(0,100) var mid_game_chance_quality_3: int = 10
@export_range(0,100) var mid_game_chance_lose_streak_quality_1: int = 40
@export_range(0,100) var mid_game_chance_lose_streak_quality_2: int = 50
@export_range(0,100) var mid_game_chance_lose_streak_quality_3: int = 10
@export_group("Late Game")
@export_range(0,100) var late_game_chance_quality_1: int = 30
@export_range(0,100) var late_game_chance_quality_2: int = 50
@export_range(0,100) var late_game_chance_quality_3: int = 20
@export_range(0,100) var late_game_chance_lose_streak_quality_1: int = 20
@export_range(0,100) var late_game_chance_lose_streak_quality_2: int = 50
@export_range(0,100) var late_game_chance_lose_streak_quality_3: int = 30


@onready var vending_animation_player: AnimationPlayer = %VendingAnimationPlayer
@onready var area: Area3D = $InteractionArea
var is_body_inside = false
var bodies: Array[Node3D]
var _interacted_player: Player
@export var _is_turned_on: bool = true

var paths_to_one_positive_quality_potions: Array[String] = [
	"res://godot_resources/potions/coolown_potion_positive_1.tres",
	"res://godot_resources/potions/health_potion_positive_1.tres",
	"res://godot_resources/potions/power_potion_positive_1.tres",
	"res://godot_resources/potions/power_slash_1.tres",
	"res://godot_resources/potions/slow_slash_1.tres",
	"res://godot_resources/potions/speed_potion_positive_1.tres"
	]

var paths_to_one_negative_quality_potions: Array[String] = [
	"res://godot_resources/potions/coolown_potion_negative_1.tres",
	"res://godot_resources/potions/health_potion_negative_1.tres",
	"res://godot_resources/potions/power_potion_negative_1.tres",
	"res://godot_resources/potions/power_slash_1.tres",
	"res://godot_resources/potions/slow_slash_1.tres",
	"res://godot_resources/potions/speed_potion_negative_1.tres",
	]

var paths_to_two_positive_quality_potions: Array[String] = [
	"res://godot_resources/potions/coolown_potion_positive_2.tres",
	"res://godot_resources/potions/health_potion_positive_2.tres",
	"res://godot_resources/potions/power_potion_positive_2.tres",
	"res://godot_resources/potions/power_slash_2.tres",
	"res://godot_resources/potions/slow_slash_2.tres",
	"res://godot_resources/potions/speed_potion_positive_2.tres"
	]

var paths_to_two_negative_quality_potions: Array[String] = [
	"res://godot_resources/potions/coolown_potion_negative_2.tres",
	"res://godot_resources/potions/health_potion_negative_2.tres",
	"res://godot_resources/potions/power_potion_negative_2.tres",
	"res://godot_resources/potions/power_slash_2.tres",
	"res://godot_resources/potions/slow_slash_2.tres",
	"res://godot_resources/potions/speed_potion_negative_2.tres",
	]

var paths_to_three_positive_quality_potions: Array[String] = [
	"res://godot_resources/potions/coolown_potion_positive_3.tres",
	"res://godot_resources/potions/health_potion_positive_3.tres",
	"res://godot_resources/potions/power_potion_positive_3.tres",
	"res://godot_resources/potions/power_slash_3.tres",
	"res://godot_resources/potions/slow_slash_3.tres",
	"res://godot_resources/potions/speed_potion_positive_3.tres"
	]

var paths_to_three_negative_quality_potions: Array[String] = [
	"res://godot_resources/potions/coolown_potion_negative_3.tres",
	"res://godot_resources/potions/health_potion_negative_3.tres",
	"res://godot_resources/potions/power_potion_negative_3.tres",
	"res://godot_resources/potions/power_slash_3.tres",
	"res://godot_resources/potions/slow_slash_3.tres",
	"res://godot_resources/potions/speed_potion_negative_3.tres",
	]

var _current_quality: int = 0
var _gold_to_level_up_vending: int = 1

func _process(delta: float) -> void:
	if(_is_turned_on):
		bodies =  area.get_overlapping_bodies()
		_handle_spending_gold()
		_handle_rolling_potion()

func _handle_spending_gold() -> void:
	if bodies != [] and Input.is_action_just_pressed("spend_money_to_vending"):
		for body: Node3D in bodies:
			if(body is Player):
				_interacted_player = body as Player
				if(body.gold>=1):
					if((body as Player).put_out_gold(_gold_to_level_up_vending)):
						_increase_quality()
					else:
						_increase_quality_failure()
					print("spend")
				_interacted_player = null

func _handle_rolling_potion() -> void:
	if bodies != [] and Input.is_action_just_pressed("roll_potion"):
		for body: Node3D in bodies:
			if(body is Player):
				_interacted_player = body as Player
				if(_current_quality >=1 and _current_quality <=3):
					(body as Player).give_potion(_roll_vending())
					print("rolled")
					_to_default_quality()
				else:
					_failed_to_roll()
				_interacted_player = null

func _roll_vending() -> String:
	var current_chance: int = _calculate_chance()
	if(_current_quality == 1):
		if(randi() % 100 < current_chance):
			return(paths_to_one_positive_quality_potions[randi() % paths_to_one_positive_quality_potions.size()])
		else:
			return(paths_to_one_negative_quality_potions[randi() % paths_to_one_negative_quality_potions.size()])
	elif(_current_quality == 2):
		if(randi() % 100 < current_chance):
			return(paths_to_two_positive_quality_potions[randi() % paths_to_two_positive_quality_potions.size()])
		else:
			return(paths_to_two_negative_quality_potions[randi() % paths_to_two_negative_quality_potions.size()])
	else:
		if(randi() % 100 < current_chance):
			return(paths_to_three_positive_quality_potions[randi() % paths_to_three_positive_quality_potions.size()])
		else:
			return(paths_to_three_negative_quality_potions[randi() % paths_to_three_negative_quality_potions.size()])

func _calculate_chance() -> int:
	if(Global.is_early_game):
		if(_current_quality == 1):
			return early_game_chance_quality_1
		elif(_current_quality == 2):
			return early_game_chance_quality_2
		else:
			return early_game_chance_quality_3
	elif(Global.is_early_game):
		if(!_interacted_player.is_on_lose_streak):
			if(_current_quality == 1):
				return mid_game_chance_quality_1
			elif(_current_quality == 2):
				return mid_game_chance_quality_2
			else:
				return mid_game_chance_quality_3
		else:
			if(_current_quality == 1):
				return mid_game_chance_lose_streak_quality_1
			elif(_current_quality == 2):
				return mid_game_chance_lose_streak_quality_2
			else:
				return mid_game_chance_lose_streak_quality_3
	else:
		if(!_interacted_player.is_on_lose_streak):
			if(_current_quality == 1):
				return late_game_chance_quality_1
			elif(_current_quality == 2):
				return late_game_chance_quality_2
			else:
				return late_game_chance_quality_3
		else:
			if(_current_quality == 1):
				return late_game_chance_lose_streak_quality_1
			elif(_current_quality == 2):
				return late_game_chance_lose_streak_quality_2
			else:
				return late_game_chance_lose_streak_quality_3
			

func _increase_quality() -> void:
	if(_current_quality == 0):
		_current_quality+=1
		_gold_to_level_up_vending+=1
	elif(_current_quality == 1):
		_current_quality+=1
		_gold_to_level_up_vending+=1
	elif(_current_quality == 2):
		_current_quality+=1
		_gold_to_level_up_vending+=1
	else:
		_increase_quality_failure()

func _increase_quality_failure() -> void:
	vending_animation_player.play("failure")

func _failed_to_roll() -> void:
	vending_animation_player.play("failure")

func _to_default_quality() -> void:
	_current_quality = 0

func turn_on() -> void:
	if(_is_turned_on == false):
		_is_turned_on = !_is_turned_on

func turn_off() -> void:
	if(_is_turned_on == true):
		_is_turned_on = !_is_turned_on
