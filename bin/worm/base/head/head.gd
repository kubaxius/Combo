class_name WormHead extends CharacterBody2D

## set by worm
var speed
var turning_speed

## set by components
var desired_movement_vector = Vector2.UP


func _grounded_state_physics_processing(delta: float) -> void:
	if speed == 0:
		return
	
	rotation = lerp_angle(rotation, desired_movement_vector.angle() + PI/2, delta*turning_speed)
	move_and_collide(Vector2.UP.rotated(rotation) * speed * delta)


func _airborn_state_physics_processing(delta: float) -> void:
	rotation = lerp_angle(rotation, Vector2.DOWN.angle() + PI/2, delta*turning_speed)
	move_and_collide(Vector2.UP.rotated(rotation) * speed * delta)

func _on_ground_checker_comp_grounded_state_changed(grounded: bool, last_ground: Node2D) -> void:
	if grounded:
		$PhysicsStateChart.send_event("segment_entered_ground")
	else:
		$PhysicsStateChart.send_event("segment_exited_ground")
