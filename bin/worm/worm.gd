class_name Worm extends Node2D

@export_range(1, 100) var speed = 10
@export_node_path("WormPath") var worm_path

func _ready() -> void:
	pass_worm_path()
	pass_speed()


func pass_worm_path():
	for node:Node in get_tree().get_nodes_in_group("needs_worm_path"):
		if is_ancestor_of(node):
			node.worm_path = get_node(worm_path)


func pass_speed():
	for node:Node in get_tree().get_nodes_in_group("needs_worm_speed"):
		if is_ancestor_of(node):
			node.speed = speed
