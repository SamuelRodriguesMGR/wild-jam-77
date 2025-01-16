class_name PotionSlot
extends AspectRatioContainer

@onready var potion_texture: TextureRect = %PotionTexture

var potion: Potion

func init_slot_with_potion(_potion: Potion) -> void:
	potion = _potion
	potion_texture.texture = potion.icon
