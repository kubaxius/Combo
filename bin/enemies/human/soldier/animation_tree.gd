extends AnimationTree


func _physics_process(_delta: float) -> void:
	set("parameters/Walk/blend_position", -get_parent().velocity.normalized().x)
