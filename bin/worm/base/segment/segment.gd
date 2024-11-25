class_name WormSegment extends RigidBody2D

## Distance from the part before.
@export var spacing:int = 31

@onready var part_before: Node2D = get_parent().get_segment_at_position(get_index() - 1)


func _ready() -> void:
	freeze = true
	position.y = get_pixel_position_in_worm()
	if has_node("PathFollowerComp"):
		$PathFollowerComp.pixel_position_in_worm = get_pixel_position_in_worm()
	connect_to_preceding()
	freeze = false


func connect_to_preceding():
	# if no preceding part, exit
	if not part_before:
		return

	$PinJoint2D.node_b = part_before.get_path()


func get_pixel_position_in_worm():
	if get_index() == 0:
		return spacing
	var segment_before: WormSegment = get_parent().get_segment_at_position(get_index() - 1)
	var pos = segment_before.get_pixel_position_in_worm() + spacing
	return pos
