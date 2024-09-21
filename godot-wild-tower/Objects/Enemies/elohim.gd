extends Node3D


var spawn_patterns: Array[Node] = []


func _ready():
	%SpawnTimer.timeout.connect(on_spawn_timer_timeout)


func on_spawn_timer_timeout():
	if spawn_patterns.size() <= 0:
		printerr("NO SPAWN PATTERNS TO SPAWN")
