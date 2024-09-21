extends Node3D

@export var spawn_patterns: Array[Node] = []
@export var activation_range: float = 20

var target: Node3D


func _ready():
	$SpawnTimer.timeout.connect(on_spawn_timer_timeout)


func _physics_process(delta):
	if target == null:
		var player = get_tree().get_first_node_in_group("player")
		if player != null:
			target = player
		else:
			print("GOD COULDN'T FIND PLAYER")
			return
	
	look_at(target.global_position)


func on_spawn_timer_timeout():
	if target == null: return
	
	if activation_range > 0 && global_position.distance_squared_to(target.global_position) > pow(activation_range, 2):
		return
	
	if spawn_patterns.size() <= 0:
		printerr("NO SPAWN PATTERNS TO SPAWN")
	
	var pattern = spawn_patterns[randi_range(0, spawn_patterns.size() - 1)]
	for point in pattern.get_children():
		point.spawn(target, get_parent())
