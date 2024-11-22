class_name WormSegment extends Node2D

var preceding_part_path:
	set(new_path):
		preceding_part_path = new_path
		connect_to_preceding()

func connect_to_preceding():
	# if no preceding part, exit
	if not preceding_part_path:
		return

	$JointLeft.node_b = preceding_part_path
	$JointRight.node_b = preceding_part_path
