extends Node3D


const DEGRY_CAMERA  : int = 300

func _physics_process(_delta: float) -> void:
	# плавная камера
	position = lerp(position, get_parent().position, 0.1)

	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseMotion and Input.is_action_pressed("right_mouse"):
		rotation.y -= event.relative.x / DEGRY_CAMERA
