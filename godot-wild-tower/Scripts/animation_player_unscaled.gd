extends AnimationPlayer

var normal_speed_scale: float


func _ready():
	normal_speed_scale = speed_scale
	#TODO WARNING this will fuck up if changed by another script during runtime
	

func _process(delta: float):
	speed_scale = normal_speed_scale / Engine.time_scale
