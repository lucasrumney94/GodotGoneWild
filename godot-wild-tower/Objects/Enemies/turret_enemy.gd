extends CharacterBody3D

@onready var rotation_root: Node3D = %RotationRoot

@export var gun: Node3D


func _ready():
	$Timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	#fire bullet
	#TODO potentially require to be able to see player or player within range
	if gun == null:
		return
	
	gun.fire_projectile()
