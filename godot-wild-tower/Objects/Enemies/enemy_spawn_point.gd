extends Node3D

@export var enemy_type: Constants.EnemyType

@export var enemy_scenes: Array[PackedScene]
@export var spawn_particles: PackedScene


func spawn(target: Node3D, spawn_parent: Node3D):
	var type_index: int = int(enemy_type)
	if enemy_type == Constants.EnemyType.OPHANIM:
		type_index = randi_range(0, 2)
	
	var enemy = enemy_scenes[type_index].instantiate()
	spawn_parent.add_child(enemy)
	enemy.global_position = global_position
	
	if type_index == int(Constants.EnemyType.MALAKIM):
		enemy.add_path_point(target)
	
	if spawn_particles != null:
		var sp = spawn_particles.instantiate()
		spawn_parent.add_child(sp)
		sp.global_position = global_position
