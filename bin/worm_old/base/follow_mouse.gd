class_name FollowMouse extends Node2D

@export_node_path("Node2D") var direction_from
@onready var node: Node2D = get_node(direction_from)

var vector_to_mouse:Vector2

func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	vector_to_mouse = node.global_position.direction_to(mouse_pos)
