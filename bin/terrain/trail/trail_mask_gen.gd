class_name TrailMaskGen extends SubViewport

@export var mask_size := Vector2i(1000, 1000)
@export var mask_scaled_up_size := Vector2i(4000, 4000)
@export var apply_mosaic := true

 
@onready var outside_cam := get_parent().get_viewport().get_camera_2d()
@onready var full_trail_viewport := $FullTrailMaskGen
@onready var mask := %Mask
@onready var mask_parallax := $MaskParallax
@onready var mosaic := $MosaicShader
var mask_scaling := Vector2.ONE
var cam: Camera2D


func _ready() -> void:
	_apply_sizing()
	if outside_cam:
		_clone_camera()
	mosaic.visible = apply_mosaic


func _process(_delta: float) -> void:
	if apply_mosaic:
		_snap_mosaic_to_screen_center()
	if outside_cam:
		_update_camera()


func _apply_sizing():
	mask_scaling.x = float(mask_scaled_up_size.x) / float(mask_size.x)
	mask_scaling.y = float(mask_scaled_up_size.y) / float(mask_size.y)
	mask_parallax.repeat_size = mask_scaled_up_size
	full_trail_viewport.size = mask_size
	mask.texture = full_trail_viewport.get_texture()
	mask.scale = mask_scaling


func _clone_camera():
	cam = outside_cam.duplicate()
	add_child(cam)


func _update_camera():
	cam.global_transform = outside_cam.global_transform


func _snap_mosaic_to_screen_center():
	mosaic.global_position = -get_canvas_transform().origin
