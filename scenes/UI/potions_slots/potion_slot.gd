class_name PotionSlot
extends AspectRatioContainer

@onready var timer_time: Label = %TimerTime
@onready var potion_texture: TextureRect = %PotionTexture

var potion: Potion

func init_slot_with_potion(_potion: Potion) -> void:
	potion = _potion
	timer_time.text = str(potion.time_to_use)
	potion_texture.texture = potion.icon
