extends CanvasLayer

signal closing

var focused_level: int = 0
#TODO this should probably be based on array of possible levels
var level_max: int = 3


func _ready():
	%BackButton.pressed.connect(on_back_pressed)
	%ResetButton.pressed.connect(on_reset_pressed)
	%LevelLeftButton.pressed.connect(on_level_changed.bind(-1))
	%LevelRightButton.pressed.connect(on_level_changed.bind(1))
	
	
	populate_stats()
	
	%BackButton.grab_focus()


func _input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		on_back_pressed()


func populate_stats():
	#TODO get stats from SaveControl
	#Fill out some shiz
	%LevelStatsContainer.populate_stats(focused_level)


func on_back_pressed():
	closing.emit()
	queue_free()


func on_reset_pressed():
	#TODO get confirmation
	SaveControl.clear_stats_data()
	populate_stats()


func on_level_changed(dir: int):
	focused_level += dir
	focused_level = clampi(focused_level, 0, level_max)
	%LevelStatsContainer.populate_stats(focused_level)
