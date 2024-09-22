extends Node

signal save_data_reset

const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {}

var old_data: Dictionary


func _ready():
	load_save_data()


func load_save_data():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		printerr("NO SAVE FILE EXISTS")
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()

	print("should be earning play_twice achievement")
	AchievementControl.earn_achievement("play_twice")


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func clear_save_data():
	old_data = save_data.duplicate()
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var blank_data: Dictionary = {}
	file.store_var(blank_data)
	save_data = blank_data.duplicate()
	save_data_reset.emit()
	save()


func clear_achievement_data():
	if !save_data.has("achievements"): return
	
	old_data = save_data.duplicate()
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	save_data.erase("achievements")
	file.store_var(save_data)
	save_data_reset.emit()
	save()


func clear_stats_data():
	if !save_data.has("stats"): return
	
	old_data = save_data.duplicate()
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	save_data.erase("stats")
	file.store_var(save_data)
	save_data_reset.emit()
	save()


func check_achievement(achievement_id: String) -> bool:
	if !save_data.has("achievements"):
		return false
	if save_data["achievements"].has(achievement_id):
		return true
	return false


func add_achievement(achievement_id: String):
	if !save_data.has("achievements"):
		save_data["achievements"] = []
	if save_data["achievements"].has(achievement_id):
		printerr("YOU'VE ALREADY ACHIEVED " + achievement_id)
		return
	save_data["achievements"].append(achievement_id)


func get_earned_achievements() -> Array:
	if save_data.has("achievements"):
		return save_data["achievements"]
	return []


func get_stat(level: int, stat_name: String) -> float:
	if !save_data.has("stats"):
		return 0
	
	var level_string = "level_" + str(level)
	if !save_data["stats"].has(level_string):
		return 0
	if save_data["stats"][level_string].has(stat_name):
		return save_data["stats"][level_string][stat_name]
	else: 
		return 0


func get_stat_cumulative(stat_name: String) -> float:
	if !save_data.has("stats"):
		return 0
	
	var result = 0
	for i in MissionControl.missions.size():
		result += get_stat(i, stat_name)
	
	return result


func get_best_stat(level: int, stat_name: String):
	if !save_data.has("stats"):
		return -1
	
	var level_string = "level_" + str(level)
	if !save_data["stats"].has(level_string):
		return -1
	if save_data["stats"][level_string].has(stat_name):
		return save_data["stats"][level_string][stat_name]
	else: 
		return -1


func get_best_stat_string(level: int, stat_name: String) -> String:
	var stat = get_best_stat(level, stat_name)
	if stat < 0:
		return "N/A"
	else: return str(stat)


#ADD STAT TO SAVE_DATA, RETURN TRUE IF IS NEW HIGH SCORE
func add_stat(level: int, stat_name: String, value) -> bool:
	if !save_data.has("stats"):
		save_data["stats"] = {}
	
	#TODO maybe if level < 0 it is intended as global stat
	#or are we just double adding everything, one for level and one for global
	#may need to save a current playthrough general stat as well to later compare for determining best time
	var level_string = "level_" + str(level)
	if !save_data["stats"].has(level_string):
		save_data["stats"][level_string] = {}
	
	var current_saved_value = get_stat(level, stat_name)
		
	match stat_name:
		"time": #record total time spent in the level
			save_data["stats"][level_string][stat_name] = current_saved_value + value
		"best_time": #compare time to current saved time
			if (current_saved_value > 0 && value < current_saved_value) || current_saved_value <= 0:
				save_data["stats"][level_string][stat_name] = value
				save()
				return true
		"kill":
			#OKAY SO WE'LL ALWAYS ADD 1 HERE, SO CAN USE VALUE TO SEND ENEMY TYPE
			save_data["stats"][level_string][stat_name] = current_saved_value + 1
			var enemy = stat_name + str(value)
			save_data["stats"][level_string][enemy] = get_stat(level, enemy) + 1
		"restart", "death":
			save_data["stats"][level_string][stat_name] = current_saved_value + 1
		"most_kills":
			var current_best = get_best_stat(level, stat_name)
			if current_best < 0 || (current_best > 0 && current_best < value):
				save_data["stats"][level_string][stat_name] = value
				save()
				return true
		"fewest_kills", "fewest_restarts", "fewest_deaths":
			var current_best = get_best_stat(level, stat_name)
			if current_best < 0 || (current_best > 0 && current_best > value):
				save_data["stats"][level_string][stat_name] = value
				save()
				return true
		_: #DEFAULT
			print(stat_name + " IS NOT A STAT NAME KNOWN TO SAVE CONTROL")
			
	return false
#TODO STATS:
#	For each level need to save:
#		Best Time
#		Total Enemies Killed
#		Number of restarts TOTAL
#		Number of deaths TOTAL
#		Fewest Kills in Successful Run
#		Most Kills in Successful Run
#		Fewest Restarts in Successful Run
#		Fewest Deaths in Successful Run
#		
#	GENERAL STATS
#		Number of total enemies killed
#		Number of specific enemies killed
#		Total number of deaths
#		Total number of restarts
#		Fastest time to Defeat GOD
