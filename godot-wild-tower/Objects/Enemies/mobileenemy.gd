extends CharacterBody3D

@export var period: float = 0.5
@export var distance: float = 5.0
@export var direction: Vector3 = Vector3(1,0,0)
@export var turnSpeed: float = 0.1

#var phaseToZero = sqrt(2)*PI/3

var originalPos: Vector3

@export var path_points: Array[Node3D] = []
@export var loop_path: bool = false
@export var path_node_tolerance: float = 0.5
var path_index: int = 0
var path_direction: int = 1


func _ready():
	originalPos = global_position
	
	
func _physics_process(delta: float) -> void:
	if path_points.size() <= 0:
		# calculate velocity
		velocity = direction * distance * (sin(Time.get_ticks_msec() / 1000 / period)) * delta;
	else:
		#follow path
		var target_pos: Vector3 = Vector3.ZERO
		if path_points.size() == 1:
			if path_index == 1:
				target_pos = originalPos
			else: target_pos = path_points[path_index].global_position
		else:
			target_pos = path_points[path_index].global_position
		
		if global_position.distance_to(target_pos) < path_node_tolerance:
			if path_points.size() == 1:
				if path_index == 0:
					path_index = 1
				else: path_index = 0
			else:
				path_index += path_direction
				if path_index >= path_points.size():
					if loop_path:
						path_index = 0
					else: 
						path_index -= 2
						path_direction = -1
				elif path_index < 0:
					if loop_path:
						path_index = path_points.size() - 1
					else:
						path_index += 2
						path_direction = 1
		var dir = (target_pos - global_position).normalized()
		velocity = dir * distance * (sin(Time.get_ticks_msec() / 1000 / period)) * delta;
	
	# SNAP calculate look direction
	# var lookdir = atan2(velocity.x, velocity.z)
	# rotation.y = lookdir # used tweening instead of a set
	
	if velocity != Vector3.ZERO:
		var lookdir = atan2(velocity.x, velocity.z)
		rotation.y = lerp(rotation.y, lookdir, turnSpeed * 50 * delta)
	
	move_and_slide()
