class_name WormHead extends WormPart

func _ready() -> void:
	pass


func setup(p_first_segment_index: int, p_speed: int, p_worm_path:Path2D = null):
	super(p_first_segment_index, p_speed, p_worm_path)
	$PathCreatorComponent.worm_path = worm_path
