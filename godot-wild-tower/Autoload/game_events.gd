extends Node

signal level_started
signal level_finished


func emit_level_started():
	print("LEVEL STARTED")
	level_started.emit()


func emit_level_finished():
	print("LEVEL FINISHED!")
	level_finished.emit()
