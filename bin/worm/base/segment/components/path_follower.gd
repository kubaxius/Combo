class_name PathFollowerComp extends AnimatableBody2D

var worm_path

func setup(p_worm_path:Path2D) -> void:
	worm_path = p_worm_path
	print(worm_path)
