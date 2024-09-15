extends Area3D


func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(body: Node3D):
	GameEvents.emit_level_finished()
