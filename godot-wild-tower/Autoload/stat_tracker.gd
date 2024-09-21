extends Node


#TODO okay so this starts up when a new level starts for the first time
#while attempting to finish the level, it counts number of reloads and deaths
# It will also track how long playing for a single playthrough
#when the level is finished, it saves
#fewest deaths
#fewest restarts

@export var level_finish_stats_scene: PackedScene
var stats_screen: CanvasLayer = null

var current_level: int = -1
var kills: int = 0
var restarts: int = 0
var deaths: int = 0

var level_finished: bool = false


func _ready():
	Callable(init).call_deferred()


func init():
	GameEvents.load_next_level.connect(on_load_next_level)
	GameEvents.level_started.connect(on_level_started)
	GameEvents.level_finished.connect(on_level_finished)
	GameEvents.level_finished_time.connect(on_level_finished_time)
	GameEvents.restarting.connect(on_restart)
	GameEvents.player_death.connect(on_death)
	GameEvents.enemy_killed.connect(on_enemy_killed)
	GameEvents.returning_to_menu.connect(on_returning_to_menu)


func on_load_next_level():
	if stats_screen != null:
		stats_screen.queue_free()
		stats_screen = null
	kills = 0
	restarts = 0
	deaths = 0
	level_finished = false


func on_level_started():
	kills = 0
	if current_level != MissionControl.current_level:
		current_level = MissionControl.current_level
		restarts = 0
		deaths = 0
		level_finished = false


func on_level_finished():
	if !level_finished:
		level_finished = true
		var new_most_kills = SaveControl.add_stat(current_level, "most_kills", kills)
		var new_fewest_kills = SaveControl.add_stat(current_level, "fewest_kills", kills)
		var new_fewest_restarts = SaveControl.add_stat(current_level, "fewest_restarts", restarts)
		var new_fewest_deaths = SaveControl.add_stat(current_level, "fewest_deaths", deaths)
		
		if stats_screen == null:
			stats_screen = level_finish_stats_scene.instantiate()
			add_child(stats_screen)
		stats_screen.set_kills(kills, new_fewest_kills, new_most_kills)
		stats_screen.set_restarts(restarts, new_fewest_restarts)
		stats_screen.set_deaths(deaths, new_fewest_deaths)


func on_level_finished_time(seconds: float):
	var new_best_time = SaveControl.add_stat(MissionControl.current_level, "best_time", seconds)
	if stats_screen == null:
		stats_screen = level_finish_stats_scene.instantiate()
		add_child(stats_screen)
	stats_screen.set_completion_time(seconds, new_best_time)


func on_restart():
	restarts += 1
	if level_finished:
		level_finished = false
		restarts = 0
		deaths = 0
	if stats_screen != null:
		stats_screen.queue_free()
		stats_screen = null


func on_death():
	if !level_finished: #in case you get killed after finishing somehow
		deaths += 1


func on_enemy_killed(_enemy_type: Constants.EnemyType, _global_pos: Vector3):
	kills += 1


func on_returning_to_menu():
	current_level = -1
	restarts = 0
	deaths = 0
	kills = 0
	level_finished = false
