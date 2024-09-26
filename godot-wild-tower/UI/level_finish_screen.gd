extends CanvasLayer


func _ready():
	%QuitButton.pressed.connect(on_quit_pressed)
	%RestartButton.pressed.connect(on_restart_pressed)
	if MissionControl.current_level < MissionControl.campaign_levels - 1:
		%NextLevelButton.pressed.connect(on_next_level_pressed)
	elif MissionControl.current_level == MissionControl.campaign_levels - 1: 
		%NextLevelButton.text = "View Credits"
		%NextLevelButton.pressed.connect(on_view_credits)
		%LevelFinishedLabel.text = "You killed God!"
	else:
		%NextLevelButton.visible = false


func set_completion_time(time: float, is_best: bool):
	%TimeLabel.text = Constants.format_time(time)
	%BestTimeLabel.visible = is_best
	if !is_best:
		%CurrentBestTimeLabel.text = "(Best: " + Constants.format_time(SaveControl.get_stat(MissionControl.current_level, "best_time")) + ")"
		%CurrentBestTimeLabel.visible = true


func set_playthrough_time(time: float, is_best: bool):
	%FullPlaytimeLabel.text = Constants.format_time(time)
	%BestFullTimeLabel.visible = is_best
	if !is_best:
		%CurrentBestFullTimeLabel.text = "(Best: " + Constants.format_time(SaveControl.get_stat(-1, "best_time")) + ")"
		%CurrentBestFullTimeLabel.visible = true
	
	%FullPlaythroughContainer.visible = true


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
		%CurrentBestKillsLabel.text = "(Fewest: " \
		+ SaveControl.get_best_stat_string(MissionControl.current_level, "fewest_kills")\
		+ ", Most: " + SaveControl.get_best_stat_string(MissionControl.current_level, "most_kills") + ")"
		%CurrentBestKillsLabel.visible = true


func set_restarts(restarts: int, is_best: bool):
	%RestartsLabel.text = str(restarts)
	%BestRestartsLabel.visible = is_best
	if !is_best:
		%CurrentBestRestartsLabel.text = "(Fewest: " + SaveControl.get_best_stat_string(MissionControl.current_level, "fewest_restarts") + ")"
		%CurrentBestRestartsLabel.visible = true


func set_deaths(deaths: int, is_best: bool):
	%DeathsLabel.text = str(deaths)
	%BestDeathsLabel.visible = is_best
	if !is_best:
		%CurrentBestDeathsLabel.text = "(Fewest: " + SaveControl.get_best_stat_string(MissionControl.current_level, "fewest_deaths") + ")"
		%CurrentBestDeathsLabel.visible = true


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


func on_view_credits():
	#return to main menu
	#open the credits screen
	get_tree().paused = false
	Engine.time_scale = 1.0
	MissionControl.load_end_credits()
	queue_free()
