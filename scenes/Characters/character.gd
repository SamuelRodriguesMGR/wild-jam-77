extends CharacterBody3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera3D = $"Camera3D"

const SPEED: float = 6.0
var transform_bonus: Vector2 = Vector2(0,0) # speed bonus and transform state

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	if is_multiplayer_authority():
		camera.make_current()
		position.y = 1
	
func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		# movement
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var mov_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if mov_dir:
			velocity.x = mov_dir.x * (SPEED + transform_bonus.x)
			velocity.z = mov_dir.z * (SPEED + transform_bonus.x)
			mov_anim(velocity)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/10)
			velocity.z = move_toward(velocity.z, 0, SPEED/10)
		
		# transformation handling
		transformation_handler()
	
	move_and_slide()

# movement animation
func mov_anim(vel: Vector3) -> void:
	if vel.x > 0:
		if transform_bonus.y == 1:
			anim.play("m_right")
		else:
			anim.play("right")
	if vel.x < 0:
		if transform_bonus.y == 1:
			anim.play("m_left")
		else:
			anim.play("left")
	if vel.z > 0:
		if transform_bonus.y == 1:
			anim.play("m_down")
		else:
			anim.play("down")
	if vel.z < 0:
		if transform_bonus.y == 1:
			anim.play("m_up")
		else:
			anim.play("up")
	if vel.x == 0 and velocity.z == 0:
		#if transform_bonus.y == 0:
			#anim.play("m_down")
		#else:
			anim.play("idle")

# change here transformation bonuses
func transformation_handler() -> void:
	if Input.is_action_pressed("transform"):
		transform_bonus.x = 13
		transform_bonus.y = 1;
	else:
		transform_bonus.x = 0
		transform_bonus.y = 0;
