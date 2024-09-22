extends Node

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
