extends MeshInstance3D
class_name Gun

@export var projectile_scene: PackedScene
@export var audio_player: AudioStreamPlayer3D

#TODO instantiate and fire projectile
#should be on some sort of delay
#does it wait until target is sighted
#how quickly can it rotate

func fire_projectile():
	if projectile_scene == null:
		printerr("NO PROJECTILE SCENE ON PROJECTILE EMITTER ON " + owner.name)
		return
		
	var projectile: Node3D = projectile_scene.instantiate()
	
	#turn off collision shape so no initial parenting collision bug if player at 0,0,0
	var col_shape: CollisionShape3D = null
	for child in projectile.get_children():
		if child is CollisionShape3D:
			col_shape = child
			col_shape.disabled = true
			break
		
	owner.get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.global_rotation = global_rotation
	
	if col_shape != null: 
		col_shape.disabled = false
	
	if projectile is Projectile:
		projectile.trajectory = global_basis.z
	#projectile is coded to move forward and die after amount of time
	
	if audio_player != null:
		audio_player.play()
