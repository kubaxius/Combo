class_name LeaveTrailComp extends Node2D


@export var texture: Texture2D

@onready var trail_viewport: TrailMaskGen = get_tree().get_first_node_in_group("trail_texture_generator_viewport")
@onready var full_trail_viewport:SubViewport = trail_viewport.get_node("FullTrailMaskGen")
@onready var active = trail_viewport and full_trail_viewport
@onready var parent:Node2D = get_parent()
@onready var sprite := Sprite2D.new()
@onready var parallax := Parallax2D.new()

var mask_scaling
var red_shader:VisualShader = preload("res://shaders/color_to_red.tres")

func _ready() -> void:
	if active:
		mask_scaling = trail_viewport.mask_scaling
		sprite.texture = texture
		sprite.scale = Vector2(1./mask_scaling.x, 1./mask_scaling.y)
		sprite.material = ShaderMaterial.new()
		sprite.z_index = 2
		var mat:ShaderMaterial = sprite.material
		mat.shader = red_shader
		full_trail_viewport.add_child(parallax)
		parallax.add_child(sprite)
		parallax.follow_viewport = false
		parallax.ignore_camera_scroll = true
		parallax.repeat_size = full_trail_viewport.size
		parallax.repeat_times = 4
		


func _physics_process(_delta: float) -> void:
	if active:
		parallax.screen_offset = -parent.global_position/mask_scaling
		sprite.global_rotation = parent.global_rotation
