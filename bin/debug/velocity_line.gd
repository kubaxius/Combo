@tool
extends Arrow


@onready var actor: Node = $".."

var velocity := Vector2.ZERO


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	head_width = 10
	global_rotation = 0
	if "velocity" in actor:
		velocity = actor.velocity
	elif "linear_velocity" in actor:
		velocity = actor.linear_velocity
	
	update_target()


func update_target():
	if velocity.length() < head_length:
		hide()
		return
	
	show()
	target = velocity
