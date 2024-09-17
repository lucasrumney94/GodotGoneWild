extends CPUParticles3D


func _ready():
	emitting = true
	finished.connect(on_finished)


func on_finished():
	queue_free()
