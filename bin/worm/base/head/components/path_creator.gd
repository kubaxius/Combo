class_name PathCreatorComp extends Marker2D

var worm_path: Path2D


var sum = 0
func _process(delta: float) -> void:
	sum += delta
	
	if sum > 0.1 and worm_path:
		sum = 0
		add_point()


var last_point: Vector2
func add_point():
	var curve := worm_path.curve
	if last_point:
		curve.add_point(global_position)
	else:
		curve.add_point(global_position)
	last_point = global_position
