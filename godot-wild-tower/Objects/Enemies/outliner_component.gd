extends Node
class_name Outliner

@export var outline_material: Material

var meshes: Array[MeshInstance3D] = []


func _ready():
	find_meshes(get_parent())


func find_meshes(base_node: Node):
	for child in base_node.get_children():
		if (child is Node3D) && child.visible:
			if child is MeshInstance3D:
				meshes.append(child)
				override_surface_material(child)
			find_meshes(child)


func override_surface_material(mesh_instance: MeshInstance3D):
	var mat: Material = mesh_instance.mesh.surface_get_material(0).duplicate()
	mat.next_pass = outline_material
	outline_material.render_priority = -1
	mesh_instance.set_surface_override_material(0, mat)


func set_mesh_outlines(setting: bool):
	for mesh in meshes:
		var outline_mat = mesh.get_surface_override_material(0).next_pass
		if setting:
			outline_mat.set_shader_parameter("size", 1.1)
		else:
			outline_mat.set_shader_parameter("size", 1.0)
