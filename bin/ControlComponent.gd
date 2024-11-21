extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var direction_vector = Vector2.ZERO
func _physics_process(delta: float) -> void:
	direction_vector = Vector2.ZERO
	if Input.is_action_pressed("up"):
		direction_vector += Vector2.UP
	if Input.is_action_pressed("down"):
		direction_vector += Vector2.DOWN
	if Input.is_action_pressed("left"):
		direction_vector += Vector2.LEFT
	if Input.is_action_pressed("right"):
		direction_vector += Vector2.RIGHT
	direction_vector = direction_vector.normalized()
	get_parent().move_and_collide(direction_vector * 10)
