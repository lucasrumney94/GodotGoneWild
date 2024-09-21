extends RigidBody3D


#var last_velocity: Vector3
var lifetime: float = 10

func _ready():
	body_entered.connect(on_body_enter)
	#print("CRYSTAL SHARD IS READY!")


func _physics_process(delta: float):
	lifetime -= delta
	if lifetime <= 0:
		#print("CRYSTAL DISAPPEARING")
		queue_free()
		
	#if velocity - last_velocity:
	

func on_body_enter(body):
	#print("CRYSTAL HITTING THING")
	GameEvents.emit_crystal_impact(global_position)
