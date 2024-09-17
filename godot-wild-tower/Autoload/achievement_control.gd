extends Node

@export var achievement_popup_scene: PackedScene
@export var achievements: Array[Achievement] = []

var new_earned_achievements: Array[Achievement] = []

var save_progress: bool = false


func earn_achievement(achievement_id: String):
	if SaveControl.check_achievement(achievement_id):
		print(achievement_id + " HAS ALREADY BEEN EARNED")
		return
		
	var achievement: Achievement = null
	for ach in achievements:
		if ach.id == achievement_id:
			achievement = ach
			break
	
	if achievement == null:
		printerr("NO ACHIEVEMENT FOUND WITH ID " + achievement_id)
		return
		
	SaveControl.add_achievement(achievement_id)
	SaveControl.save()
	
	var popup = get_tree().get_first_node_in_group("achievement_popup")
	if popup == null:
		popup = achievement_popup_scene.instantiate()
		add_child(popup)
	
	popup.add_achievement(achievement)
