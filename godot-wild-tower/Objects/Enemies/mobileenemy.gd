extends CharacterBody3D

@export var period: float = 0.5
@export var distance: float = 5.0
@export var direction: Vector3 = Vector3(1,0,0)

#var phaseToZero = sqrt(2)*PI/3

var originalPos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _physics_process(delta: float) -> void:
	# calculate velocity
	velocity = direction * distance * (sin(Time.get_ticks_msec() / 1000 / period)) * delta;
	
	# calculate look direction
	
	var lookdir = atan2(velocity.x, velocity.z)
	rotation.y = lookdir # TODO: use tweening instead of a set
	move_and_slide()
