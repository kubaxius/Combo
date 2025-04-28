@icon("res://components/component_icon.svg")
class_name LeaveTrailComp extends Node
## This component makes that it's parent traces a transparent trail in the ground.
##
## It is mainly used by the worm segments, but it can also be applied to
## any weapon that penetrates the earth, for example missles tracing the worm.


@export var texture: Texture2D

@onready var parent:Node2D = get_parent()

@onready var sprite := Sprite2D.new()
@onready var parallax := Parallax2D.new()

@onready var trail_viewport: TrailMaskGen = get_tree().get_first_node_in_group("trail_texture_generator_viewport")
var full_trail_viewport:SubViewport

var red_shader:VisualShader = preload("res://shaders/color_to_red.tres")

func _ready() -> void:
	if trail_viewport:
		full_trail_viewport = trail_viewport.get_node("FullTrailMaskGen")
	if trail_viewport and full_trail_viewport:
		_setup_sprite()
		_setup_parallax()
	
	set_physics_process(trail_viewport and full_trail_viewport)


func _physics_process(_delta: float) -> void:
	_copy_parents_transform()


func _setup_sprite():
	sprite.texture = texture
	sprite.scale = Vector2(1./trail_viewport.mask_scaling.x, 1./trail_viewport.mask_scaling.y)
	sprite.material = ShaderMaterial.new()
	sprite.z_index = 2
	sprite.material.shader = red_shader


func _setup_parallax():
	parallax.add_child(sprite)
	full_trail_viewport.add_child(parallax)
	parallax.follow_viewport = false
	parallax.ignore_camera_scroll = true
	parallax.repeat_size = full_trail_viewport.size
	parallax.repeat_times = 4


func _copy_parents_transform():
	parallax.screen_offset = -parent.global_position/trail_viewport.mask_scaling
	sprite.global_rotation = parent.global_rotation
