extends Node

signal level_started
signal level_finished
signal restarting
signal level_finished_time(seconds: float)
signal partial_time(seconds: float)
signal enemy_killed(enemy_type: Constants.EnemyType)

signal player_hit_floor(global_pos: Vector3)
signal player_jump(global_pos: Vector3)
signal player_dash
signal player_enemy_dash
signal long_fall_started
signal player_death

#TODO this might not be the best place for this
#update when we have some way of changing levels
#var current_level: int = 0


func emit_level_started():
	print("LEVEL STARTED")
	level_started.emit()


func emit_level_finished():
	print("LEVEL FINISHED!")
	level_finished.emit()


func emit_restarting():
	#TODO need to check if player is still alive... or not?
	SaveControl.add_stat(MissionControl.current_level, "restart", 1)
	restarting.emit()


func emit_level_finished_time(seconds: float):
	level_finished_time.emit(seconds)
	SaveControl.add_stat(MissionControl.current_level, "time", seconds)


func emit_partial_time(seconds: float):
	partial_time.emit(seconds)


func emit_enemy_killed(enemy_type: Constants.EnemyType):
	enemy_killed.emit(enemy_type)
	SaveControl.add_stat(MissionControl.current_level, "kill", enemy_type)


func emit_player_hit_floor(global_pos: Vector3):
	player_hit_floor.emit(global_pos)


func emit_player_jump(global_pos: Vector3):
	player_jump.emit(global_pos)


func emit_player_dash():
	player_dash.emit()


func emit_player_enemy_dash():
	player_enemy_dash.emit()


func emit_long_fall_started():
	long_fall_started.emit()


func emit_player_death():
	player_death.emit()
	SaveControl.add_stat(MissionControl.current_level, "death", 1)
