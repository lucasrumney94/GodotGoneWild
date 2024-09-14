extends CharacterBody3D

@export var period: float = 0.5
@export var distance: float = 5.0


var direction: float 

# Called when the node enters the scene tree for the first time.
func _ready():
	direction = 1.0
	
	
	
func _physics_process(delta: float) -> void:
	velocity.x = direction * delta * 1000
	move_and_slide()

func switch_dir():
	direction *= -1
