class_name LeaveTrailComp extends Node2D


@export var texture: Texture2D

@onready var trail_viewport:SubViewport = get_tree().get_first_node_in_group("full_trail_texture_generator_viewport")
@onready var parent:Node2D = get_parent()
@onready var sprite := Sprite2D.new()
@onready var parallax := Parallax2D.new()


func _ready() -> void:
	if trail_viewport:
		sprite.texture = texture
		trail_viewport.add_child(parallax)
		parallax.add_child(sprite)
		parallax.follow_viewport = false
		parallax.ignore_camera_scroll = true
		parallax.repeat_size = trail_viewport.size
		parallax.repeat_times = 4


func _physics_process(_delta: float) -> void:
	if trail_viewport:
		parallax.screen_offset = -parent.global_position
		sprite.global_rotation = parent.global_rotation
