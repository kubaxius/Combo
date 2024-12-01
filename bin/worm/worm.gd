class_name Worm extends Node2D

## Expressed in km/h.
@export_custom(PROPERTY_HINT_RANGE, "1,200,1,suffix:km/h") var base_speed := 50.:
	get():
		# Convert into px/s
		return Utils.kmph_to_pps(base_speed)
@export_range(0.1, 1, 0.1) var acceleration := 0.5
@export_range(1, 2, 0.1) var base_turning_speed := 1.
@export_range(1, 10, 0.1) var boost_speed_multiplier := 2.
@export_node_path("WormPath") var worm_path

var speed:
	set(new_speed):
		speed = new_speed
		_pass_speed_to_children()
var desired_speed:float
var turning_speed:
	set(new_turning_speed):
		turning_speed = new_turning_speed
		_pass_turning_speed_to_children()
var is_boosted = false
var is_moving = true

func _ready() -> void:
	desired_speed = base_speed
	speed = base_speed
	turning_speed = base_turning_speed
	_pass_worm_path_to_children()
	_pass_speed_to_children()
	_pass_turning_speed_to_children()


func _physics_process(delta: float) -> void:
	_calculate_speed(delta)


func _calculate_speed(delta: float) -> void:
	if speed < desired_speed:
		speed = ceil(lerp(float(speed), float(desired_speed), 10*delta*acceleration))
	elif speed > desired_speed:
		speed = floor(lerp(float(speed), float(desired_speed), 10*delta*acceleration))


func _pass_worm_path_to_children() -> void:
	for node:Node in get_tree().get_nodes_in_group("needs_worm_path"):
		if is_ancestor_of(node):
			node.worm_path = get_node(worm_path)


func _pass_speed_to_children() -> void:
	for node:Node in get_tree().get_nodes_in_group("needs_worm_speed"):
		if is_ancestor_of(node):
			node.speed = speed



func _pass_turning_speed_to_children() -> void:
	for node:Node in get_tree().get_nodes_in_group("needs_worm_turning_speed"):
		if is_ancestor_of(node):
			node.turning_speed = turning_speed


func apply_boost() -> void:
	if not is_boosted:
		desired_speed = base_speed * boost_speed_multiplier
		is_boosted = true


func remove_boost() -> void:
	if is_boosted:
		desired_speed = base_speed
		is_boosted = false


func stop_moving() -> void:
	if is_moving:
		desired_speed = 0
		is_moving = false


func start_moving() -> void:
	if not is_moving:
		desired_speed = base_speed
		is_moving = true
