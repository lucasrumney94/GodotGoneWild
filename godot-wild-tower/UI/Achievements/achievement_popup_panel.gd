extends PanelContainer

signal popup_panel_remove(panel: Control)


func _ready():
	$TimerUnscaled.timeout.connect(on_timer_timeout)


func setup_achievement(ach: Achievement):
	%TextureRect.texture = ach.icon
	%NameLabel.text = ach.title
	%DescriptionLabel.text = ach.description


func on_timer_timeout():
	$AnimationPlayer.play("exit")


func destroy():
	popup_panel_remove.emit(self)
	queue_free()
