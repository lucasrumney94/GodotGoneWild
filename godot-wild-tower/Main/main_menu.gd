extends CanvasLayer

@export var options_scene: PackedScene


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
	pass


func on_options_pressed():
	#INSTANTIATE OPTIONS SCENE
	#BIND focus_on_button(%OptionsButton) TO OPTIONS CLOSING SIGNAL
	var options_menu = options_scene.instantiate()
	add_child(options_menu)
	options_menu.closing.connect(focus_on_button.bind(%OptionsButton))


func on_quit_pressed():
	#CLOSE THE APPLICATION
	# TODO POSSIBLY WITH CONFIRMATION/FEEDBACK LINK
	get_tree().quit()
