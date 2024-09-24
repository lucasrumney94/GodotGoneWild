extends Node

@export var default_mouse_sensitivity: float = 0.5
@export var default_slowdown_duration: float = 0.75
@export var default_invert_look_y: bool = false

var mouse_sensitivity: float = 0.5
var slowdown_duration: float = 0.75
var invert_look_y: bool = false


func _ready():
	Callable(init).call_deferred()


func init():
	get_player_prefs()


func reset_to_default():
	mouse_sensitivity = default_mouse_sensitivity
	slowdown_duration = default_slowdown_duration
	invert_look_y = default_invert_look_y


func get_player_prefs():
	var value
	
	value = PlayerPrefs.get_setting("mouse_sensitivity")
	if value >= 0:
		mouse_sensitivity = value
	else: mouse_sensitivity = default_mouse_sensitivity
	
	value = PlayerPrefs.get_setting("slowdown_duration")
	if value >= 0:
		slowdown_duration = value
	else: slowdown_duration = default_slowdown_duration
	
	value = PlayerPrefs.get_setting("invert_look_y")
	if value >= 0:
		invert_look_y = bool(value)
	else: invert_look_y = default_invert_look_y
	
	for i in AudioServer.bus_count:
		var bus_name = AudioServer.get_bus_name(i)
		value = PlayerPrefs.get_setting("audio_" + bus_name)
		if value >= 0:
			set_audio_bus_volume(value, bus_name)


func set_audio_bus_volume(volume_percent: float, bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(volume_percent))
