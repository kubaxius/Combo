class_name WormPath extends Path2D

@export_range(1, 200) var point_distance:int = 30
@export_range(100, 20000) var max_length:int = 1000
@export_node_path("WormHead") var worm_head_path
@onready var worm_head = get_node(worm_head_path)

signal path_changed


func _physics_process(delta: float) -> void:
	update_path()


var last_point: Vector2
func update_path():
	var dist_sq = last_point.distance_squared_to(worm_head.global_position)
	if not dist_sq >= point_distance*point_distance:
		return
	
	add_point()
	
	if curve.get_baked_length() > max_length:
		remove_point()
	path_changed.emit()


func add_point():
	curve.add_point(worm_head.global_position)
	last_point = worm_head.global_position


func remove_point():
	curve.remove_point(0)
