extends Node3D

@export var pause_menu_scene: PackedScene
var pause_menu = null


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if pause_menu == null:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			pause_menu = pause_menu_scene.instantiate()
			add_child(pause_menu)
			pause_menu.closing.connect(on_unpause)
			get_tree().paused = true
		#else:
			#pause_menu.queue_free()
			#pause_menu = null
			#on_unpause()
	
	if event.is_action_pressed("restart") && pause_menu == null:
		get_tree().paused = false
		Engine.time_scale = 1.0
		get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)


func on_unpause():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
