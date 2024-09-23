extends Node

@export var default_mouse_sensitivity: float = 0.5
@export var default_slowdown_duration: float = 0.75

var mouse_sensitivity: float = 0.5
var slowdown_duration: float = 0.75


func reset_to_default():
	mouse_sensitivity = default_mouse_sensitivity
	slowdown_duration = default_slowdown_duration
