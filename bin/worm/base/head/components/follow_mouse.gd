@icon("res://components/component_icon.svg")
class_name FollowMouseComp extends Node2D

@onready var parent: WormHead = get_parent()


func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	parent.desired_movement_vector = parent.global_position.direction_to(mouse_pos)
	
