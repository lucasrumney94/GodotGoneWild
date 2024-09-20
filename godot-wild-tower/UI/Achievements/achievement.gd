extends Resource
class_name Achievement

@export var id: String
@export var icon: Texture2D
@export var title: String
@export_multiline var description: String

@export var stat: String
@export var stat_goal: int
@export var check_function: String = ""
@export var custom_string: String = ""
