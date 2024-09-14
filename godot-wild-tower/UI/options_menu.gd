extends CanvasLayer

signal closing


func _ready():
	%BackButton.pressed.connect(on_back_pressed)
	
	%BackButton.grab_focus()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		Callable(on_back_pressed).call_deferred()


func on_back_pressed():
	closing.emit()
	queue_free()
