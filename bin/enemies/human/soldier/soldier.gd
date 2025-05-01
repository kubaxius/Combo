class_name Soldier extends Enemy


@export_range(0., 1., 0.05) var shot_spread := 0.05
@export_range(-1, 300, 1) var mag_capacity := 30

@onready var idle_destination: float = global_position.x


var bullet = preload("res://projectiles/bullet/bullet.tscn")

var attack_target: Node2D

@onready var bullets_in_mag = mag_capacity

# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

var tick_rate = 0.2
var tick = 0
func _physics_process(delta: float) -> void:
	choose_target()
	super(delta)

	


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
	var sgn = Utils.get_random_sign(Global.movement_rng)
	var offset = Global.movement_rng.randi_range(50, 100)
	idle_destination += sgn * offset
	Debug.draw_debug_dot(Vector2(idle_destination, 0), 5, true)


func _start_moving_to_idle_destination() -> void:
	velocity.x = speed * sign(idle_destination - global_position.x)


func choose_target():
	var target_player = get_closest_visible_player()
	if target_player:
		attack_target = target_player
	else:
		attack_target = null


func shoot_target():
	if not attack_target:
		return
	var direction = attack_target.global_position - global_position
	shoot(direction)


func shoot(direction: Vector2):
	if is_mag_empty():
		return
	
	var bullet_inst: Bullet = bullet.instantiate()
	bullet_inst.setup(global_position, direction, shot_spread, 400, 4)
	get_parent().add_child(bullet_inst)
	bullets_in_mag -= 1


func is_mag_empty() -> bool:
	if bullets_in_mag == 0:
		return true
	return false
