extends CanvasLayer

@export var popup_panel: PackedScene

var panels: Array[Control] = []

var achievements_to_add: Array[Achievement] = []

var panel_add_delay: float = 0.5


func _ready():
	$TimerUnscaled.wait_time = panel_add_delay
	$TimerUnscaled.timeout.connect(on_timer_timeout)


func add_achievement(ach: Achievement):
	achievements_to_add.append(ach)
	if $TimerUnscaled.is_stopped():
		add_panel()


func add_panel():
	if achievements_to_add.size() <= 0:
		printerr("TRIED TO ADD ACHIEVEMENT BUT NO MORE TO ADD!")
		return
		
	var ach = achievements_to_add[0]
	var popup: Control = popup_panel.instantiate() as Control
	$VBoxContainer.add_child(popup)
	popup.setup_achievement(ach)
	panels.append(popup)
	popup.popup_panel_remove.connect(on_popup_panel_remove)
	
	achievements_to_add.remove_at(0)
	$TimerUnscaled.start()


func on_popup_panel_remove(popup: Control):
	panels.erase(popup)
	if panels.size() <= 0:
		queue_free()


func on_timer_timeout():
	if achievements_to_add.size() > 0:
		add_panel()
