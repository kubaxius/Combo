class_name DockPath extends Path2D


func get_closest_point(global_pos:Vector2) -> Vector2:
	var pos = global_pos - global_position
	return global_position + curve.get_closest_point(pos)
