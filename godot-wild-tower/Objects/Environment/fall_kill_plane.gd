extends Area3D


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body):
	if !(body is PlayerControl) && body is RigidBody3D:
		#basically if is falling platform
		body.queue_free()
