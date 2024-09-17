extends CanvasLayer

signal closing


func _ready():
	%BackButton.pressed.connect(on_back_pressed)
	%ResetButton.pressed.connect(on_reset_pressed)
	
	populate_stats()
	
	%BackButton.grab_focus()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		on_back_pressed()


func populate_stats():
	#TODO get stats from SaveControl
	#Fill out some shiz
	pass


func on_back_pressed():
	closing.emit()
	queue_free()


func on_reset_pressed():
	SaveControl.clear_stats_data()
	populate_stats()
