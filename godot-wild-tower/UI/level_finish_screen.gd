extends CanvasLayer


func _ready():
	%QuitButton.pressed.connect(on_quit_pressed)
	%RestartButton.pressed.connect(on_restart_pressed)
	if MissionControl.current_level < MissionControl.campaign_levels - 1:
		%NextLevelButton.pressed.connect(on_next_level_pressed)
	else: %NextLevelButton.visible = false


func set_completion_time(time: float, is_best: bool):
	%TimeLabel.text = Constants.format_time(time)
	%BestTimeLabel.visible = is_best


func set_kills(kills: int, fewest: bool, most: bool):
	%KillsLabel.text = str(kills)
	if most:
		%BestKillsLabel.text = "New Most Kills!"
		%BestKillsLabel.visible = true
	elif fewest:
		%BestKillsLabel.text = "New Fewest Kills!"
		%BestKillsLabel.visible = true
	else:
		%BestKillsLabel.visible = false


func set_restarts(restarts: int, is_best: bool):
	%RestartsLabel.text = str(restarts)
	%BestRestartsLabel.visible = is_best


func set_deaths(deaths: int, is_best: bool):
	%DeathsLabel.text = str(deaths)
	%BestDeathsLabel.visible = is_best


func restart_level():
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)


func on_quit_pressed():
	get_tree().paused = false
	Engine.time_scale = 1.0
	GameEvents.emit_returning_to_menu()
	SaveControl.save()
	get_tree().change_scene_to_file("res://Main/main_menu.tscn")
	queue_free()


func on_restart_pressed():
	get_tree().paused = false
	Engine.time_scale = 1.0
	GameEvents.emit_restarting()
	Callable(restart_level).call_deferred()
	queue_free()


func on_next_level_pressed():
	get_tree().paused = false
	Engine.time_scale = 1.0
	MissionControl.load_next_level()
	queue_free()
