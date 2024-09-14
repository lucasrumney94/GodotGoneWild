extends CanvasLayer

signal closing


func _ready():
	%ResumeButton.pressed.connect(on_resume_pressed)
	
	%ResumeButton.grab_focus()


#func _input(event: InputEvent):
	#if event.is_action_pressed("ui_cancel"):
		#on_resume_pressed()


func on_resume_pressed():
	closing.emit()
	queue_free()
