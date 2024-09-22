extends Node
class_name TimerUnscaled

signal timeout

@export var wait_time: float = 1.0
@export var one_shot: bool = false
@export var autostart: bool = false

var stopped: bool = true
var time: float = 0


func _ready():
	if autostart:
		stopped = false


func _process(delta: float):
	if stopped: return
	
	time += delta / Engine.time_scale
	if time > wait_time:
		time -= wait_time
		timeout.emit()
		if one_shot:
			stopped = true
			time = 0


func is_stopped() -> bool:
	return stopped


func start(time_sec: float = -1):
	if stopped:
		time = 0
	stopped = false
	if time_sec > 0:
		wait_time = time_sec
