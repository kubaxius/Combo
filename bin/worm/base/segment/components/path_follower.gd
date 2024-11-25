@tool class_name PathFollowerComp extends Node2D

@export var pull_power = 2

@onready var path_follower:SegmentPathFollower = $SegmentPathFollower

var enabled = false

#
var worm_path:WormPath:
	set(new_worm_path):
		worm_path = new_worm_path
		try_setup()
var speed:int:
	set(new_speed):
		speed = new_speed
		try_setup()
var pixel_position_in_worm:int:
	set(new_pixel_position_in_worm):
		pixel_position_in_worm = new_pixel_position_in_worm
		try_setup()


func _init() -> void:
	add_to_group("needs_worm_path")
	add_to_group("needs_worm_speed")


func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	if not has_node("SegmentPathFollower"):
		warnings.append("This node needs to have SegmentPathFollower as it's child.")
	
	return warnings


func _physics_process(_delta: float) -> void:
	if enabled:
		pull()


func try_setup():
	if speed == null or worm_path == null or pixel_position_in_worm == null:
		return
	path_follower.reparent(worm_path)
	path_follower.enabled = true
	path_follower.setup(speed, pixel_position_in_worm)
	enabled = true


func pull():
	var parent:RigidBody2D = get_parent()
	var force = path_follower.global_position - parent.global_position
	parent.apply_central_force(force * 100000 * pull_power)
