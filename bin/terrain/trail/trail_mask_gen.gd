class_name TrailMaskGen extends SubViewport

@export var mask_size = Vector2i(1000, 1000)
@export var mask_scaled_up_size = Vector2i(4000, 4000)

 
@onready var outside_cam := get_parent().get_viewport().get_camera_2d()
@onready var full_trail_viewport = $FullTrailMaskGen
var mask_scaling := Vector2.ONE
var cam: Camera2D


func _ready() -> void:
	mask_scaling.x = float(mask_scaled_up_size.x) / float(mask_size.x)
	mask_scaling.y = float(mask_scaled_up_size.y) / float(mask_size.y)
	$Parallax2D.repeat_size = mask_scaled_up_size
	full_trail_viewport.size = mask_size
	$Parallax2D/Mask.texture = full_trail_viewport.get_texture()
	$Parallax2D/Mask.scale = mask_scaling
	
	
	if outside_cam:
		cam = outside_cam.duplicate()
		add_child(cam)


func _process(_delta: float) -> void:
	$Mosaic.global_position = -get_canvas_transform().origin
	if outside_cam:
		cam.global_transform = outside_cam.global_transform
