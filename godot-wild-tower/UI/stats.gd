extends CanvasLayer

signal closing


func _ready():
	%BackButton.pressed.connect(on_back_pressed)
	
	%BackButton.grab_focus()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		on_back_pressed()


func on_back_pressed():
	closing.emit()
	queue_free()
