extends Enemy



@onready var idle_destination: float = global_position.x

var tick = 0.
func _physics_process(delta: float) -> void:
	tick += delta
	if tick > 0.05:
		shoot()
		tick = 0

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
func shoot():
	var target = get_closest_visible_player()
	if not target:
		return
	
	
	var bullet_inst: Bullet = bullet.instantiate()
	var direction = -target.global_position.angle_to(global_position) - PI/2
	bullet_inst.setup(direction, 400, 4)
	bullet_inst.global_position = global_position
	get_parent().add_child(bullet_inst)


func burst():
	pass
