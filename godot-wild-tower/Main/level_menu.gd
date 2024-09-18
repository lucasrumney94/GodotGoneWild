extends MenuButton


func _ready():
	#get levels from missionControl add to menu
	#when you click, start that level
	var popup = get_popup()
	for mission in MissionControl.missions:
		var scene_name: String = get_scene_name(mission)
		popup.add_item(scene_name)
	
	popup.id_pressed.connect(on_pressed)


func on_pressed(id: int):
	#var focused_item: int = get_popup().get_focused_item()
	get_tree().change_scene_to_packed(MissionControl.missions[id])
	
	
func get_scene_name(scene: PackedScene) -> String:
	var instance = scene.instantiate()
	var result: String = instance.name
	instance.queue_free()
	return result
