extends CanvasLayer

@onready var timer_label: Label = $TimerLabel

var accrue_time: bool = false
var elapsed_time: float = 0

func _ready():
	Callable(init).call_deferred()


func init():
	GameEvents.level_started.connect(on_level_started)
	GameEvents.level_finished.connect(on_level_finished)
	GameEvents.restarting.connect(on_restarting)


func _process(delta):
	if !accrue_time: return
	
	elapsed_time += delta / Engine.time_scale
	timer_label.text = format_time(elapsed_time)


func format_time(seconds: float) -> String:
	var minutes = floor(seconds / 60.0)
	var remaining_seconds = floor(seconds - (minutes * 60))
	var centiseconds = (seconds - (minutes * 60) - remaining_seconds) * 100
	return ("%02d" % minutes) + ":" + ("%02d" % remaining_seconds) + ":" + ("%02d" % centiseconds)


func on_level_started():
	accrue_time = true


func on_level_finished():
	if accrue_time:
		GameEvents.emit_level_finished_time(elapsed_time)
	accrue_time = false


func on_restarting():
	if accrue_time:
		GameEvents.emit_partial_time(elapsed_time)
