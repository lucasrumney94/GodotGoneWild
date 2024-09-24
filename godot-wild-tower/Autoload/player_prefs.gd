extends Node

const SAVE_FILE_PATH = "user://player_prefs.pref"

var save_data: Dictionary = {}


func _ready():
	load_save_data()


func load_save_data():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		printerr("NO PLAYER PREFS SAVE FILE EXISTS")
		return
	
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)
	

func update_setting(setting_name: String, new_value):
	save_data[setting_name] = new_value


func get_setting(setting_name: String):
	if !save_data.has(setting_name):
		return -1
	
	return save_data[setting_name]
