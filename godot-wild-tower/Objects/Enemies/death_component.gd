extends Node
class_name DeathComponent

@export var enemy_type: Constants.EnemyType

@export var explosion_particles: PackedScene


func die(push_vector: Vector3):
	#find all visible mesh instance 3d
	#for each, instantiate a RigidBody3D at their location
	#add a child of type CollisionShape3D to the rb the size of mesh bounding box
	explode_meshes(get_parent(), push_vector)
	#SaveControl.add_stat(GameEvents.current_level, "kill", enemy_type)
	GameEvents.emit_enemy_killed(enemy_type)
	owner.queue_free()


func explode_meshes(base_node: Node, push_vector: Vector3):
	for child in base_node.get_children():
		if (child is Node3D) && child.visible:
			if child is MeshInstance3D:
				explode_mesh(child, push_vector)
			explode_meshes(child, push_vector)


func explode_mesh(mesh: MeshInstance3D, push_vector: Vector3):
	if mesh.is_in_group("explode") && explosion_particles != null:
		var ep = explosion_particles.instantiate()
		ep.position = mesh.global_position
		owner.get_parent().add_child(ep)
		mesh.queue_free()
	
	var rb: RigidBody3D = RigidBody3D.new()
	rb.position = mesh.global_position
	rb.collision_layer = 8
	rb.collision_mask = 1
	#rb.gravity_scale = 0.1
	var col: CollisionShape3D = CollisionShape3D.new()
	col.shape = BoxShape3D.new()
	col.shape.size = mesh.get_aabb().size
	rb.add_child(col)
	owner.get_parent().add_child(rb)
	mesh.reparent(rb)
	
	rb.set_inertia(Vector3.ZERO)
	#rb.apply_impulse(Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5)))
	rb.apply_impulse(push_vector * 10 + Vector3(randf_range(-5, 5), randf_range(-5, 5), randf_range(-5, 5)))
	rb.apply_torque_impulse(Vector3(randf_range(-100, 100), randf_range(-100, 100), randf_range(-100, 100)))
	
	if mesh.get_surface_override_material(0) != null:
		mesh.set_surface_override_material(0, null)
		
	#TODO make debris disappear after some amount of time
	
	
