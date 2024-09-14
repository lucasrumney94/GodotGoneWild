extends CanvasLayer

signal closing

#@export var main_menu_scene: PackedScene
@export var options_scene: PackedScene
var options_menu = null


func _ready():
	%ResumeButton.pressed.connect(on_resume_pressed)
	%RestartButton.pressed.connect(on_restart_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	
	%ResumeButton.grab_focus()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		if options_menu != null: return
		
		Callable(on_resume_pressed).call_deferred()


func on_resume_pressed():
	closing.emit()
	queue_free()


func on_restart_pressed():
	#TODO TWO WAYS TO GO ABOUT THIS
	#1. RELOAD THE WHOLE SCENE
	#2. RESET ALL OBJECTS TO STARTING POSITION
	pass


func on_options_pressed():
	options_menu = options_scene.instantiate()
	get_parent().add_child(options_menu)
	options_menu.closing.connect(on_options_closed)


func on_options_closed():
	%OptionsButton.grab_focus()
	options_menu = null


func on_quit_pressed():
	#quit back to main menu
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main/main_menu.tscn")
