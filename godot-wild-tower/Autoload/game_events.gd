extends Node

signal level_started
signal level_finished

#TODO this might not be the best place for this
#update when we have some way of changing levels
var current_level: int = 0


func emit_level_started():
	print("LEVEL STARTED")
	level_started.emit()


func emit_level_finished():
	print("LEVEL FINISHED!")
	level_finished.emit()
