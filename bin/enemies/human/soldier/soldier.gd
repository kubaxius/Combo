extends CharacterBody2D

var real_walking_speed = 5


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

# -------------------------------- #
#          State methods           #
# -------------------------------- #

func _on_idle_walking_state_entered() -> void:
	_set_new_idle_destination()
	print("walking")
	_idle_around()


func _on_idle_standing_state_entered() -> void:
	print("standing")
	velocity.x = 0


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

var destination: float = global_position.x
func _idle_around():
	if sign(destination) < 0:
		if global_position.x <= destination:
			$StateChart.send_event("reached_destination")
	else:
		if global_position.x >= destination:
			$StateChart.send_event("reached_destination")
	
	var walking_speed = Utils.kmph_to_pps(real_walking_speed)
	velocity.x = walking_speed * sign(destination - global_position.x)


func _set_new_idle_destination() -> void:
	var sign = Global.movement_rng.randi_range(-1, 1)
	var offset = Global.movement_rng.randi_range(50, 100)
	destination += sign * offset
	print(destination)


func _move_distance():
	pass
