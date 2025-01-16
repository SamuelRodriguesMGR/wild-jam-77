class_name Player
extends CharacterBody3D


@onready var anim              : AnimationPlayer = get_node("AnimationPlayer")
@onready var camera            : Camera3D = get_node("%Camera3D")
@onready var camera_controller : Node3D = get_node("CameraController")
@onready var hitbox            : HitBox = $HitBox
@onready var hitbox_shape      : CollisionShape3D = $HitBox/Shape
@onready var hurtbox_shape     : CollisionShape3D = $HurtBox/Collision
@onready var info_label        : Label3D = $Info
@onready var hp_label          : Label3D = $HP
@onready var potion_slots_ui   : PotionSlotsUI = %PotionSlotsUI

# таймеры
@onready var attack_cooldown    : Timer = $Timers/attack_cooldown
@onready var attack_duration    : Timer = $Timers/attack_duration
@onready var transform_cooldown : Timer = $Timers/transform_cooldown
@onready var transform_duration : Timer = $Timers/transform_duration

@export var gold : int = 3
#for tests
@export var is_local: bool = false
#

const SPEED    : float = 12.0
const FRICTION : float = 0.95

var hp                  : int = 100
var move_direction      : Vector2 = Vector2.ZERO
var last_move_direction : Vector2 = Vector2.UP
var transform_bonus     : Vector2 = Vector2.ZERO # speed bonus and transform state
var resp_room           : Vector2 = Vector2(50, -50)
var anim_flag           : bool    = false

var is_attack_ready    : bool = true
var is_transform_ready : bool = true

var is_on_lose_streak: bool = false

var _potions_slots: PotionSlots

func _enter_tree() -> void:
	# уникальный id игрока (я хз)
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	# если игрок авторизован
	if is_multiplayer_authority() or is_local:
		# имя
		info_label.text = name
		# делаем камеру повышенной в звании
		camera.make_current()
		# стартовая позиция
		position.y = 1
		_init_potions_slots()

func _physics_process(_delta: float) -> void:
	# если игрок авторизован
	if is_multiplayer_authority() or is_local:
		get_input()
		move()
		move_and_slide()
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		velocity.z = move_toward(velocity.z, 0, FRICTION)
		
		# обработка ивентов с атакой
		if Input.is_action_pressed("transform") and is_transform_ready:
			transformation_handler()

		if Input.is_action_pressed("attack") and is_attack_ready:
			attack_handler()

		if Input.is_action_just_pressed("drink_potion"):
			_potions_slots.drink_potion()
		
		# жизни
		hp_label.text = str(hp)
		
		# смерть
		if hp <= 0:
			position = Vector3(resp_room.x, position.y, resp_room.y)
			hp = 100
		
		

func move():
	# конвектируем в 3д вектор
	var dir : Vector3 = (
		camera_controller.transform.basis * Vector3(move_direction.x, 0, move_direction.y)
		).normalized() 
	
	if dir:
		velocity.x = dir.x * (SPEED + transform_bonus.x)
		velocity.z = dir.z * (SPEED + transform_bonus.x)
	
func get_input():
	if not anim_flag:
		move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") 
		mov_anim()
	else:
		move_direction = Vector2.ZERO

# получение урона
func TakeDamage(damage : int) -> void:
	if transform_bonus.y == 0:
		hp -= damage

# обработка атаки
func attack_handler() -> void:
	if transform_bonus.y == 0:
		is_attack_ready = false
		anim_flag = true
		hitbox.visible = true
		hitbox_shape.disabled = false
		attack_duration.start()
		attack_cooldown.start()
		
		var punch_anim: StringName
		hitbox.rotation_degrees.y = camera_controller.rotation_degrees.y
		
		if last_move_direction.x > 0 and last_move_direction.y == 0:
			punch_anim = "punch_right"
			hitbox.rotation_degrees.y -= 90
		if last_move_direction.x < 0 and last_move_direction.y == 0:
			punch_anim = "punch_left"
			hitbox.rotation_degrees.y += 90
		if last_move_direction.y > 0:
			punch_anim = "punch_down"
			hitbox.rotation_degrees.y += 180
		if last_move_direction.y < 0:
			punch_anim = "punch_up"
			
			
		anim.play(punch_anim)
		# не включать mov_anim в process, он будет прерывать await и он не сработает
		await anim.animation_finished
		
func _on_attack_duration_timeout() -> void:
	#hitbox.visible = false
	hitbox_shape.disabled = true
	anim_flag = false
	
func _on_attack_cooldown_timeout() -> void:
	is_attack_ready = true
	
# обработка трансформации
func transformation_handler() -> void:
	is_transform_ready = false
	transform_bonus = Vector2(13, 1)
	transform_duration.start()
	transform_cooldown.start()
	
func _on_transform_duration_timeout() -> void:
	transform_bonus.x = 0
	transform_bonus.y = 0
	
func _on_transform_cooldown_timeout() -> void:
	is_transform_ready = true
	
# анимация движения
func mov_anim() -> void:
	if transform_bonus.y == 0:
		if move_direction.x > 0 and move_direction.y == 0:
			anim.play("right")
		if move_direction.x < 0 and move_direction.y == 0:
			anim.play("left")
		if move_direction.y > 0:
			anim.play("down")
		if move_direction.y < 0:
			anim.play("up")
		if move_direction.x == 0 and move_direction.y == 0:
			if last_move_direction.x > 0:
				anim.play("idle_right")
			if last_move_direction.x < 0:
				anim.play("idle_left")
			if last_move_direction.y > 0:
				anim.play("idle_down")
			if last_move_direction.y < 0:
				anim.play("idle_up")
	else:
		if move_direction.x > 0 and move_direction.y == 0:
			anim.play("m_right")
		if move_direction.x < 0 and move_direction.y == 0:
			anim.play("m_left")
		if move_direction.y > 0:
			anim.play("m_down")
		if move_direction.y < 0:
			anim.play("m_up")
		if move_direction.x == 0 and move_direction.y == 0:
			anim.play("m_down")
			
	if move_direction != Vector2.ZERO:
		last_move_direction = move_direction
	
	
## позиция мышки в 3д
#func _get_mouse_position(_cmask: int) -> Vector3:
	#var mpos: Vector2 = get_viewport().get_mouse_position()
	#var rS: Vector3 = camera.project_ray_origin(mpos)
	#var rE: Vector3 = rS + camera.project_ray_normal(mpos) * 2000
	#var sstate: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	#var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(rS, rE)
	#var result: Dictionary = sstate.intersect_ray(query)
	#if result.size() > 1:
		#return result.position
	#else:
		#return Vector3(0,0,0)
	#
	
	
func _init_potions_slots() -> void:
	_potions_slots = PotionSlots.new()
	_potions_slots.potion_slots_updated.connect(potion_slots_ui._on_potion_slots_updated)
	_potions_slots.potion_slots_updated.emit(_potions_slots.potions)

func give_potion(path_to_potion_resource: String) -> void:
	var duplicated_potion: Potion = load(path_to_potion_resource).duplicate(false)
	duplicated_potion.potion_is_used.connect(_on_potion_is_used)
	duplicated_potion.potion_ended.connect(_on_potion_ended)
	_potions_slots.put_potion_in(duplicated_potion)

func _on_potion_is_used(potion: Potion) -> void:
	var speed: int = 10
	var hp: int = 10
	var attack_damage: int = 10
	var coold_down: int = 12
	var plus_damage_to_next_attack: bool = false
	var slow_play_to_next_attack: bool = false
	if potion.potion == Potion.potion_type.SPEED_POSITIVE:
		print("Old speed: ", speed)
		var reverse_effect_amount: int = 0
		if(potion.is_percents):
			reverse_effect_amount = speed*(potion.effect_amount/100 +1)
			speed+=reverse_effect_amount
		else:
			reverse_effect_amount = potion.effect_amount
			speed+=potion.effect_amount
		print("New speed: ", speed)
		print("Speed Positive is drinked")
		await get_tree().create_timer(potion.time_to_use).timeout
		potion.potion_ended.emit(potion, reverse_effect_amount)
	elif potion.potion == Potion.potion_type.SPEED_NEGATIVE:
		print("Old speed: ", speed)
		var reverse_effect_amount: int = 0
		if(potion.is_percents):
			reverse_effect_amount = speed*(potion.effect_amount/100 +1)
			speed-=reverse_effect_amount
		else:
			reverse_effect_amount = potion.effect_amount
			speed-=potion.effect_amount
		print("New speed: ", speed)
		print("Speed negative is drinked")
		await get_tree().create_timer(potion.time_to_use).timeout
		potion.potion_ended.emit(potion, reverse_effect_amount)
	elif potion.potion == Potion.potion_type.POWER_POSITIVE:
		print("Old damage: ", attack_damage)
		var reverse_effect_amount: int = 0
		if(potion.is_percents):
			reverse_effect_amount = attack_damage*(potion.effect_amount/100 +1)
			attack_damage+=reverse_effect_amount
		else:
			reverse_effect_amount = potion.effect_amount
			attack_damage+=potion.effect_amount
		print("New damage: ", attack_damage)
		print("Damage Positive is drinked")
		await get_tree().create_timer(potion.time_to_use).timeout
		potion.potion_ended.emit(potion, reverse_effect_amount)
	elif potion.potion == Potion.potion_type.POWER_NEGATIVE:
		print("Old damage: ", attack_damage)
		var reverse_effect_amount: int = 0
		if(potion.is_percents):
			reverse_effect_amount = attack_damage*(potion.effect_amount/100 +1)
			attack_damage-=reverse_effect_amount
		else:
			reverse_effect_amount = potion.effect_amount
			attack_damage-=potion.effect_amount
		print("New damage: ", attack_damage)
		print("Damage Negative is drinked")
		await get_tree().create_timer(potion.time_to_use).timeout
		potion.potion_ended.emit(potion, reverse_effect_amount)
	elif potion.potion == Potion.potion_type.COOLDOWN_POSITIVE:
		print("Old cooldown: ", coold_down)
		var reverse_effect_amount: int = 0
		if(potion.is_percents):
			reverse_effect_amount = coold_down
			coold_down -= coold_down*(potion.effect_amount/100 +1)
			reverse_effect_amount -= coold_down
		else:
			reverse_effect_amount = coold_down
			coold_down -= potion.effect_amount
			reverse_effect_amount -= coold_down
		print("New cooldown: ", coold_down)
		print("Cooldown Positive is drinked")
		await get_tree().create_timer(potion.time_to_use).timeout
		potion.potion_ended.emit(potion, reverse_effect_amount)
	elif potion.potion == Potion.potion_type.COOLDOWN_NEGATIVE:
		print("Old cooldown: ", coold_down)
		var reverse_effect_amount: int = 0
		if(potion.is_percents):
			reverse_effect_amount = coold_down*(potion.effect_amount/100 +1)
			coold_down += reverse_effect_amount
		else:
			reverse_effect_amount = potion.effect_amount
			coold_down += potion.effect_amount
		print("New cooldown: ", coold_down)
		print("Cooldown Negative is drinked")
		await get_tree().create_timer(potion.time_to_use).timeout
		potion.potion_ended.emit(potion, reverse_effect_amount)
	elif potion.potion == Potion.potion_type.HEAL_POSITIVE:
		print("Old hp: ", hp)
		if(potion.is_percents):
			hp += hp*(potion.effect_amount/100 +1)
		else:
			hp += potion.effect_amount
		print("New hp: ", hp)
	elif potion.potion == Potion.potion_type.HEAL_NEGATIVE:
		print("Old hp: ", hp)
		if(potion.is_percents):
			hp -= hp*(potion.effect_amount/100 +1)
		else:
			hp -= potion.effect_amount
		print("New hp: ", hp)
	elif potion.potion == Potion.potion_type.POWER_SLASH:
		print("Power Slash drinked")
	elif potion.potion == Potion.potion_type.SLOW_SLASH:
		print("Slow Slash drinked")
	else:
		pass

func _on_potion_ended(potion: Potion, reverse_effect_amount: int) -> void:
	var speed: int = 10
	var hp: int = 10
	var attack_damage: int = 10
	var coold_down: int = 12
	var plus_damage_to_next_attack: bool = false
	var slow_play_to_next_attack: bool = false
	print("Reverse effect is ", reverse_effect_amount)
	if potion.potion == Potion.potion_type.SPEED_POSITIVE:
		speed-=reverse_effect_amount
	elif potion.potion == Potion.potion_type.SPEED_NEGATIVE:
		speed+=reverse_effect_amount
	elif potion.potion == Potion.potion_type.POWER_POSITIVE:
		attack_damage-=reverse_effect_amount
	elif potion.potion == Potion.potion_type.POWER_NEGATIVE:
		attack_damage+=reverse_effect_amount
	elif potion.potion == Potion.potion_type.COOLDOWN_POSITIVE:
		coold_down+=reverse_effect_amount
	elif potion.potion == Potion.potion_type.COOLDOWN_NEGATIVE:
		coold_down-=reverse_effect_amount
	elif potion.potion == Potion.potion_type.POWER_SLASH:
		print("Slash ended")
	elif potion.potion == Potion.potion_type.SLOW_SLASH:
		print("Slash drinked")
	else:
		pass

#Функция такая маленькая, потому что можно будет включать VFX.
func put_out_gold(minus: int) -> bool:
	if(gold-minus >= 0):
		gold-=minus
		return true
	return false
