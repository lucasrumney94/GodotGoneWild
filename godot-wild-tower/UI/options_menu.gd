extends CanvasLayer

signal closing


func _ready():
	%BackButton.pressed.connect(on_back_pressed)
	
	%BackButton.grab_focus()


func on_back_pressed():
	closing.emit()
	queue_free()
