extends Node

@export var missions: Array[PackedScene] = []

@export var campaign_levels: int = 3
var current_level = 0

var loading_credits: bool = false


func load_next_level():
	var next: int = current_level + 1
	if next >= missions.size():
		printerr("NO NEXT LEVEL TO LOAD")
		return
	
	current_level = next
	GameEvents.emit_load_next_level()
	Callable(do_load_next_level).call_deferred()


func load_end_credits():
	loading_credits = true
	get_tree().change_scene_to_file("res://Main/main_menu.tscn")


func do_load_next_level():
	get_tree().change_scene_to_packed(missions[current_level])
