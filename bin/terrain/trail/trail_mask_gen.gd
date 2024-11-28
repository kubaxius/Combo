class_name TrailMaskGen extends SubViewport

@export var mask_size = Vector2i(4000, 4000)

@onready var outside_cam := get_parent().get_viewport().get_camera_2d()
var cam: Camera2D


func _ready() -> void:
	$Parallax2D.repeat_size = mask_size
	$FullTrailMaskGen.size = mask_size
	
	if outside_cam:
		cam = outside_cam.duplicate()
		add_child(cam)


func _process(_delta: float) -> void:
	if outside_cam:
		cam.global_position = outside_cam.global_position
