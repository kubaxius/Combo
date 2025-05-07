class_name PhysicsUtils extends Node


static func apply_air_drag(velocity: Vector2, delta: float, drag_coefficient: float = 0.001) -> Vector2:
	
	var drag_force = velocity.normalized() * velocity.length_squared() * drag_coefficient
	
	return velocity - (drag_force * delta)
