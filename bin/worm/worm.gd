class_name Worm extends Node2D

@export_range(1, 100) var base_speed := 6
@export_range(1, 2, 0.1) var base_turning_speed := 1.
@export_range(1, 10, 0.1) var boost_speed_multiplier := 2.
@export_node_path("WormPath") var worm_path

var speed:
	set(new_speed):
		speed = new_speed
		pass_speed()
var turning_speed:
	set(new_turning_speed):
		turning_speed = new_turning_speed
		pass_turning_speed()
var is_boosted = false

func _ready() -> void:
	speed = base_speed
	turning_speed = base_turning_speed
	pass_worm_path()
	pass_speed()
	print(turning_speed)
	pass_turning_speed()


func pass_worm_path():
	for node:Node in get_tree().get_nodes_in_group("needs_worm_path"):
		if is_ancestor_of(node):
			node.worm_path = get_node(worm_path)


func pass_speed():
	for node:Node in get_tree().get_nodes_in_group("needs_worm_speed"):
		if is_ancestor_of(node):
			node.speed = speed



func pass_turning_speed():
	for node:Node in get_tree().get_nodes_in_group("needs_worm_turning_speed"):
		if is_ancestor_of(node):
			node.turning_speed = turning_speed


func apply_boost():
	if not is_boosted:
		speed = base_speed * boost_speed_multiplier
		is_boosted = true


func remove_boost():
	if is_boosted:
		speed = base_speed
		is_boosted = false
