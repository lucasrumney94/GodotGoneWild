extends Area3D
class_name Projectile

@export var impact_particles: PackedScene
var trajectory: Vector3 = Vector3.FORWARD
@export var speed: float = 50
@export var lifetime: float = 5

func _ready():
	body_entered.connect(on_body_entered)


func _physics_process(delta):
	global_position += trajectory * speed * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()


func on_body_entered(body: Node3D):
	impact()


func impact():
	GameEvents.emit_projectile_impact(global_position)
	var particles = impact_particles.instantiate()
	get_parent().add_child(particles)
	particles.global_position = global_position
	queue_free()


func emit_projectile_impact():
	impact()
