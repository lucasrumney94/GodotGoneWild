extends CharacterBody3D

@export var spawn_patterns: Array[Node] = []
@export var activation_range: float = 50
@export var spawn_delay: float = 5

@export var move_speed: float = 100
@export var move_points: Array[Node3D] = []
var move_index: int = -1

var target: Node3D

@export var invincibility_time: float = 5.0


func _ready():
	$SpawnTimer.wait_time = spawn_delay
	$SpawnTimer.timeout.connect(on_spawn_timer_timeout)
	$InvincibilityTimer.timeout.connect(on_invincibility_timeout)
	
	$DeathComponent.hurt.connect(on_hurt)


func _physics_process(delta):
	
	if move_index >= 0 && move_index < move_points.size():
		#move toward selected move point
		var dir = (move_points[move_index].global_position - global_position).normalized()
		#velocity = dir * distance * (sin(Time.get_ticks_msec() / 1000 / period)) * delta;
		velocity = dir * move_speed * delta
		move_and_slide()
	
	if target == null:
		var player = get_tree().get_first_node_in_group("player")
		if player != null:
			target = player
		else:
			print("GOD COULDN'T FIND PLAYER")
			return
	
	if target.global_position != global_position:
		%RotationRoot.look_at(target.global_position)
		%SpawnPatterns.look_at(Vector3(target.global_position.x, %SpawnPatterns.global_position.y, target.global_position.z))
	
	if activation_range > 0 && global_position.distance_squared_to(target.global_position) < pow(activation_range, 2):
		if $SpawnTimer.is_stopped():
			$SpawnTimer.start()


func on_spawn_timer_timeout():
	if target == null: return
	
	if activation_range > 0 && global_position.distance_squared_to(target.global_position) > pow(activation_range, 2):
		return
	
	if spawn_patterns.size() <= 0:
		printerr("NO SPAWN PATTERNS TO SPAWN")
	
	var pattern = spawn_patterns[randi_range(0, spawn_patterns.size() - 1)]
	for point in pattern.get_children():
		point.spawn(target, get_parent())
	
	$SpawnTimer.start()


func on_invincibility_timeout():
	$CollisionShape3D.disabled = false


func on_hurt():
	print("GOD HAS BEEN HURT!")
	move_index += 1
	$InvincibilityTimer.start(invincibility_time)
	$CollisionShape3D.disabled = true
