extends RigidBody3D

@export var fall_delay: float = 1.0
@export var rumble_intensity: float = 0.1

var falling: bool = false

var player_body: PlayerControl


func _ready():
	$Area3D.body_entered.connect(on_body_entered)
	$Area3D.body_exited.connect(on_body_exited)
	$Timer.timeout.connect(on_timer_timeout)
	$Timer.wait_time = fall_delay
	

func on_body_entered(body):
	if falling: return
	
	if !(body is PlayerControl):
		return
	
	$Timer.start()
	falling = true
	#make_rumble()
	$AudioStreamPlayer3D.play()
	player_body = body
	player_body.toggle_camera_shake(true)


func on_body_exited(body):
	if body == player_body:
		player_body.toggle_camera_shake(false)


func make_rumble():
	var tween = create_tween()
	tween.tween_method(rumble, 0.0, 1.0, fall_delay)


func rumble(percent: float):
	rotation = Vector3(randf_range(-rumble_intensity, rumble_intensity), 0, randf_range(-rumble_intensity, rumble_intensity)) * percent


func on_timer_timeout():
	$AudioStreamPlayer3D.stop()
	freeze = false
	if player_body != null:
		player_body.toggle_camera_shake(false)
