extends CharacterBody3D

@onready var rotation_root: Node3D = %RotationRoot

@export var gun: Node3D

@export var rotation_speed: float = 1.0
@export var tilt_limit: float = 45

@export var activation_radius: float = 20

var target: Node3D = null


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	tilt_limit = deg_to_rad(tilt_limit)
	

func _physics_process(delta):
	#target player
	if target == null:
		var player = get_tree().get_first_node_in_group("player")
		if player != null:
			target = player
		else:
			print("TURRET COULDN'T FIND PLAYER")
			return
	
	if activation_radius <= 0 || global_position.distance_squared_to(target.global_position) > pow(activation_radius, 2):
		return
		
	if $Timer.is_stopped():
		$Timer.start()
	
	#TURN TOWARD TARGET
	var target_pos = target.global_position
	var local_tp = to_local(target_pos)
	var theta = wrapf(atan2(local_tp.x, local_tp.z) - rotation_root.rotation.y, -PI, PI)
	rotation_root.rotation.y += clamp(rotation_speed * delta, 0, abs(theta)) * sign(theta)
	
	#okay dipshit now do the x axis
	theta = wrapf(atan2(-local_tp.y, Vector2(local_tp.x, local_tp.z).length()) - rotation_root.rotation.x, -PI, PI)
	var xrot = rotation_root.rotation.x + clamp(rotation_speed * delta, 0, abs(theta)) * sign(theta)
	rotation_root.rotation.x = clampf(xrot, -tilt_limit, tilt_limit)


func on_timer_timeout():
	if activation_radius <= 0 || global_position.distance_squared_to(target.global_position) > pow(activation_radius, 2):
		return
	#fire bullet
	#TO/DO potentially require to be able to see player or player within range
	if gun == null:
		return
	
	gun.fire_projectile()
	$Timer.start()
