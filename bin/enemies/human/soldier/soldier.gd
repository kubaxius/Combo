class_name Soldier extends Enemy


@export_range(0., 1., 0.05) var shot_spread := 0.05
@export_range(0, 30, 1) var shots_per_burst := 3

@onready var idle_destination: float = global_position.x


var shoot_cooldown := 0.
var bursted_count := 0

# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

var tick := 0.
func _physics_process(delta: float) -> void:
	if tick > 0.2:
		var target = get_closest_visible_player()
		if not target:
			return
		shoot(target)
		tick = 0.
	tick += delta

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
	Debug.draw_debug_dot(Vector2(idle_destination, 0), 5, true)


func _start_moving_to_idle_destination() -> void:
	velocity.x = speed * sign(idle_destination - global_position.x)


var bullet = preload("res://projectiles/bullet/bullet.tscn")
func shoot(target: Node2D):
	var bullet_inst: Bullet = bullet.instantiate()
	var direction = -target.global_position.angle_to(global_position) - PI/2
	var direction_deviation = randf_range(-shot_spread, shot_spread)
	bullet_inst.setup(global_position, direction + direction_deviation, 400, 4)
	get_parent().add_child(bullet_inst)


func burst():
	var target = get_closest_visible_player()
	if not target:
		return
	
	var tween = get_tree().create_tween()
	
