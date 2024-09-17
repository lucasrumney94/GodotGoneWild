extends CanvasLayer

signal closing

@export var achievement_panel: PackedScene


func _ready():
	%BackButton.pressed.connect(on_back_pressed)
	%ResetButton.pressed.connect(on_reset_pressed)
	
	populate_achievements()
	
	%BackButton.grab_focus()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		on_back_pressed()


func populate_achievements():
	#clear out achievement container
	for child in %AchievementsContainer.get_children():
		child.queue_free()
		
	#TODO get achievements from achievement control
	#get earned achievements from save control
	#display all achievements
	#highlight earned achievements
	#only earned achievements show flavor text (description)
	var earned: Array = SaveControl.get_earned_achievements()
	for ach in AchievementControl.achievements:
		add_achievement_panel(ach, earned.has(ach.id))


func add_achievement_panel(ach: Achievement, earned: bool):
	var panel = achievement_panel.instantiate()
	%AchievementsContainer.add_child(panel)
	panel.setup_panel(ach, earned)


func on_back_pressed():
	closing.emit()
	queue_free()


func on_reset_pressed():
	#TODO ask for confirmation
	SaveControl.clear_achievement_data()
	populate_achievements()
