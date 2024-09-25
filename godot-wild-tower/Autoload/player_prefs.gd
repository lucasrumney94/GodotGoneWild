extends Node

const SAVE_FILE_PATH = "user://player_prefs.cfg"

var save_data: Dictionary = {}

#TO/DO save this as an ini file or json
#rather than the normal encrypted looking godot save type
#What you are looking for is ConfigFile


func _ready():
	load_save_data()


func load_save_data():
	#OLD WAY
	#if !FileAccess.file_exists(SAVE_FILE_PATH):
		#printerr("NO PLAYER PREFS SAVE FILE EXISTS")
		#return
	#
	#var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	#save_data = file.get_var()
	
	var config = ConfigFile.new()
	
	#Load data from a file
	var err = config.load(SAVE_FILE_PATH)
	#if file didn't load, ignore it
	if err != OK:
		print("PLAYER PREFS CONFIG FILE FAILED TO LOAD")
		return
		
	for key in config.get_section_keys("settings"):
		save_data[key] = config.get_value("settings", key)


func save():
	#OLD WAY
	#var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	#file.store_var(save_data)
	
	var config = ConfigFile.new()
	
	for key in save_data.keys():
		config.set_value("settings", key, save_data[key])
		
	config.save(SAVE_FILE_PATH)
	

func update_setting(setting_name: String, new_value):
	save_data[setting_name] = new_value


func get_setting(setting_name: String):
	if !save_data.has(setting_name):
		return -1
	
	return save_data[setting_name]
