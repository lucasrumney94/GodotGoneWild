extends CharacterBody3D

@export var period: float = 0.5
@export var distance: float = 5.0


var direction: float 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
func _physics_process(delta: float) -> void:
	position.x += distance * direction * delta


func switch_dir():
	direction *= -1
