extends CharacterBody2D

var real_walking_speed = 5
var walking_speed:
	get():
		return Utils.kmph_to_pps(real_walking_speed)

@onready var idle_destination: float = global_position.x

# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func _check_if_idle_destination_reached() -> void:
	if sign(velocity.x) < 0:
		if global_position.x <= idle_destination:
			$StateChart.send_event("reached_destination")
	else:
		if global_position.x >= idle_destination:
			$StateChart.send_event("reached_destination")


func _set_new_idle_destination() -> void:
	var sign = Utils.get_random_sign(Global.movement_rng)
	var offset = Global.movement_rng.randi_range(50, 100)
	idle_destination += sign * offset
	Debug.draw_debug_dot(Vector2(idle_destination, 0), Utils.get_random_color(), 5, true)


func _start_moving_to_idle_destination() -> void:
	velocity.x = walking_speed * sign(idle_destination - global_position.x)


func got_eaten():
	queue_free()
