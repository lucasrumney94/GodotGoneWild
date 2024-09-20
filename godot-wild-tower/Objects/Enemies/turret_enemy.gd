extends CharacterBody3D

@onready var rotation_root: Node3D = %RotationRoot

@export var gun: Node3D

@export var rotation_speed: float = 5.0

var target: Node3D = null


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	

func _physics_process(delta):
	#target player
	if target == null:
		var player = get_tree().get_first_node_in_group("player")
		if player != null:
			target = player
		else:
			print("TURRET COULDN'T FIND PLAYER")
			return
	
	var target_pos = target.global_position + Vector3.UP
	var xz_target_pos: Vector3 = Vector3(target_pos.x, 0, target_pos.z)
	var xz_pos: Vector3 = Vector3(rotation_root.global_position.x, 0, rotation_root.global_position.z)
	var xz_look = rotation_root.global_basis.z
	xz_look = xz_look.slide(Vector3.UP)
	var yangle: float = xz_look.signed_angle_to((xz_target_pos - xz_pos).normalized(), Vector3.UP)
	rotation_root.global_rotation.y = lerp_angle(rotation_root.global_rotation.y, yangle, delta * rotation_speed)
	#rotation_root.look_at(target_pos)


func on_timer_timeout():
	#fire bullet
	#TODO potentially require to be able to see player or player within range
	if gun == null:
		return
	
	gun.fire_projectile()
