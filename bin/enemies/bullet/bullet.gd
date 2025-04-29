class_name Bullet extends CharacterBody2D

var speed = 150
var direction_vector := Vector2(1, 0)
var damage := 5

func setup(p_direction_vector: Vector2, p_speed: int):
	direction_vector = p_direction_vector
	speed = p_speed


func _physics_process(delta: float) -> void:
	move_and_collide(direction_vector * speed * delta)
