extends CanvasLayer

signal closing


func _ready():
	%BackButton.pressed.connect(on_back_pressed)
	%BackButton.grab_focus()
	
	#TODO add achievement for viewing credits
	Callable(init).call_deferred()


func init():
	print("should be earning credit achievement")
	AchievementControl.earn_achievement("view_credits")


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		on_back_pressed()


func on_back_pressed():
	closing.emit()
	queue_free()
