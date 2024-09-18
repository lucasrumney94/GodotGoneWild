extends MeshInstance3D

@export var projectile_scene: PackedScene

#TODO instantiate and fire projectile
#should be on some sort of delay
#does it wait until target is sighted
#how quickly can it rotate

func fire_projectile():
	var projectile: Node3D = projectile_scene.instantiate()
	projectile.position = global_position
	projectile.rotation = global_rotation
	owner.add_child(projectile)
	#projectile is coded to move forward and die after amount of time
