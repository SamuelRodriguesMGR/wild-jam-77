extends Node3D

@onready var potion_slots: PotionSlots = $PotionSlots
@onready var potion_slots_2: PotionSlotsUI = $PotionSlots2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	potion_slots.potion_slots_updated.connect(potion_slots_2._on_potion_slots_updated)
	potion_slots.potion_slots_updated.emit(potion_slots.potions)

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("attack")):
		potion_slots.drink_potion()
	elif(Input.is_action_just_pressed("transform")):
		var rand: int = randi_range(0,2)
		if(rand == 0):
			potion_slots.put_potion_in((load("res://godot_resources/potions/health_potion_positive_1.tres") as Potion))
		elif (rand == 1):
			potion_slots.put_potion_in((load("res://godot_resources/potions/health_potion_positive_3.tres") as Potion))
		elif (rand == 2):
			potion_slots.put_potion_in((load("res://godot_resources/potions/health_potion_positive_2.tres") as Potion))
