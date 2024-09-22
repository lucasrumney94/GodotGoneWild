extends CanvasLayer

signal closing

#@export var main_menu_scene: PackedScene
@export var options_scene: PackedScene
var options_menu = null

var seconds_paused:float = 0.0
var seconds_to_earn_achievement = 60.0

func _ready():
	%ResumeButton.pressed.connect(on_resume_pressed)
	%RestartButton.pressed.connect(on_restart_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	
	%ResumeButton.grab_focus()

func _process(delta: float) -> void:
	seconds_paused += delta;
	if(seconds_paused>seconds_to_earn_achievement):
		AchievementControl.earn_achievement("pause_long")

func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		if options_menu != null: return
		
		Callable(on_resume_pressed).call_deferred()


func restart_level():
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)


func on_resume_pressed():
	seconds_paused = 0.0
	closing.emit()
	queue_free()


func on_restart_pressed():
	#TO/DO TWO WAYS TO GO ABOUT THIS
	get_tree().paused = false
	Engine.time_scale = 1.0
	GameEvents.emit_restarting()
	#2. RESET ALL OBJECTS TO STARTING POSITION
	
	Callable(restart_level).call_deferred()


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
	Engine.time_scale = 1.0
	GameEvents.emit_returning_to_menu()
	SaveControl.save()
	get_tree().change_scene_to_file("res://Main/main_menu.tscn")
