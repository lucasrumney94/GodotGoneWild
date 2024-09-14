extends CharacterBody3D

@export var mouse_sensitivity: float = 0.5
@export var tilt_lower_limit: float = deg_to_rad((-89))
@export var tilt_upper_limit: float = deg_to_rad(89)

var mouse_rotation: Vector3


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			#TODO go to a pause screen and pause it
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent):
	var mouse_input: bool = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if mouse_input:
		var rotation_input: float = -event.relative.x * mouse_sensitivity
		var tilt_input: float = -event.relative.y * mouse_sensitivity
		update_camera(get_process_delta_time(), rotation_input, tilt_input)


func update_camera(delta: float, rotation_input: float, tilt_input: float):
	mouse_rotation.x += tilt_input * delta
	mouse_rotation.x = clamp(mouse_rotation.x, tilt_lower_limit, tilt_upper_limit)
	mouse_rotation.y += rotation_input * delta
	
	%CameraRotationRoot.transform.basis = Basis.from_euler(mouse_rotation)
	%CameraRotationRoot.rotation.z = 0.0#lean_rotation#
	
	#shapecast_look_root.rotation.y = camera_rotation_root.rotation.y + PI
	
	rotation_input = 0.0
	tilt_input = 0.0
