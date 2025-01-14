extends CharacterBody3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera3D = $"Camera3D"
@onready var hitbox: HitBox = $HitBox
@onready var hitbox_shape: CollisionShape3D = $HitBox/Shape
@onready var hurtbox_shape: CollisionShape3D = $HurtBox/Collision
@onready var info_label: Label3D = $Info
@onready var hp_label: Label3D = $HP

	# таймеры
@onready var attack_cooldown: Timer = $Timers/attack_cooldown
@onready var attack_duration: Timer = $Timers/attack_duration
@onready var transform_cooldown: Timer = $Timers/transform_cooldown
@onready var transform_duration: Timer = $Timers/transform_duration

const SPEED: float = 6.0
var hp: int = 100
var input_dir: Vector2
var transform_bonus: Vector2 = Vector2(0,0) # speed bonus and transform state
var resp_room: Vector2 = Vector2(50, -50)

var is_attack_ready:bool = true
var is_transform_ready:bool = true


func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	if is_multiplayer_authority():
		camera.make_current()
		position.y = 1

func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		# движение
		input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var mov_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if mov_dir:
			velocity.x = mov_dir.x * (SPEED + transform_bonus.x)
			velocity.z = mov_dir.z * (SPEED + transform_bonus.x)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/10)
			velocity.z = move_toward(velocity.z, 0, SPEED/10)
		mov_anim()

		# обработка ивентов с кд
		if Input.is_action_pressed("transform") and is_transform_ready:
			transformation_handler()
		if Input.is_action_pressed("attack") and is_attack_ready:
			attack_handler()
		
		# инфа для дебага
		info_label.text = name
		hp_label.text = str(hp)
		
		if hp <= 0:
			position = Vector3(resp_room.x, position.y, resp_room.y)
		
	move_and_slide()


# пользовательские функции

	# получение урона
func TakeDamage(damage: int) -> void:
	if transform_bonus.y == 0:
		hp -= damage

	# обработка атаки
func attack_handler() -> void:
	if transform_bonus.y == 0:
		var pos: Vector3 = _get_mouse_position(collision_mask)
		hitbox.look_at(Vector3(pos.x, position.y, pos.z), Vector3(0,1,0))
		is_attack_ready = false
		hitbox.visible = true
		hitbox_shape.disabled = false
		attack_duration.start()
		attack_cooldown.start()	
func _on_attack_duration_timeout() -> void:
	hitbox.visible = false
	hitbox_shape.disabled = true
func _on_attack_cooldown_timeout() -> void:
	is_attack_ready = true

	# обработка трансформации
func transformation_handler() -> void:
	is_transform_ready = false
	transform_bonus.x = 13
	transform_bonus.y = 1
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
		if input_dir.x > 0:
			anim.play("right")
		if input_dir.x < 0:
			anim.play("left")
		if input_dir.y > 0:
			anim.play("down")
		if input_dir.y < 0:
			anim.play("up")
		if input_dir.x == 0 and input_dir.y == 0:
			anim.play("idle")
	else:
		if input_dir.x > 0:
			anim.play("m_right")
		if input_dir.x < 0:
			anim.play("m_left")
		if input_dir.y > 0:
			anim.play("m_down")
		if input_dir.y < 0:
			anim.play("m_up")
		if input_dir.x == 0 and input_dir.y == 0:
			anim.play("m_down")

	# позиция мышки в 3д
func _get_mouse_position(cmask: int) -> Vector3:
	var mpos: Vector2 = get_viewport().get_mouse_position()
	var rS: Vector3 = camera.project_ray_origin(mpos)
	var rE: Vector3 = rS + camera.project_ray_normal(mpos) * 2000
	var sstate: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(rS, rE)
	var result: Dictionary = sstate.intersect_ray(query)
	if result.size() > 1:
		return result.position
	else:
		return Vector3(0,0,0)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
