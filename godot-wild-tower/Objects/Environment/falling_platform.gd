extends RigidBody3D

@export var fall_delay: float = 1.0
@export var rumble_intensity: float = 0.1

var falling: bool = false


func _ready():
	$Area3D.body_entered.connect(on_body_entered)
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = fall_delay
	

func on_body_entered(body):
	if falling: return
	
	$Timer.start()
	falling = true
	make_rumble()


func make_rumble():
	var tween = create_tween()
	tween.tween_method(rumble, 0.0, 1.0, fall_delay)


func rumble(percent: float):
	rotation = Vector3(randf_range(-rumble_intensity, rumble_intensity), 0, randf_range(-rumble_intensity, rumble_intensity)) * percent


func on_timer_timeout():
	freeze = false
