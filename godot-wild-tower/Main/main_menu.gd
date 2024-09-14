extends CanvasLayer

@export var options_scene: PackedScene

#TODO we'll need to sophisticate this a bit, just doing this to get things running
# down line should have multiple scenes for each level
# as well as a save system
@export var main_game_scene: PackedScene

#TODO stats screen (also integrated into save system)
#TODO add a credits screen


func _ready():
	%StartButton.pressed.connect(on_start_pressed)
	%OptionsButton.pressed.connect(on_options_pressed)
	%QuitButton.pressed.connect(on_quit_pressed)
	
	%StartButton.grab_focus()


func focus_on_button(button: Button):
	if button == null: return
	
	button.grab_focus()


func on_start_pressed():
	#MOVE TO MAIN GAME SCENE
	get_tree().change_scene_to_packed(main_game_scene)


func on_options_pressed():
	#INSTANTIATE OPTIONS SCENE
	#BIND focus_on_button(%OptionsButton) TO OPTIONS CLOSING SIGNAL
	var options_menu = options_scene.instantiate()
	add_child(options_menu)
	options_menu.closing.connect(focus_on_button.bind(%OptionsButton))


func on_quit_pressed():
	#CLOSE THE APPLICATION
	# TODO POSSIBLY WITH CONFIRMATION POPUP/FEEDBACK LINK
	get_tree().quit()
