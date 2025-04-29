class_name Enemy extends CharacterBody2D


@export_range(0, 100) var real_speed := 5
var speed:
	get():
		return Utils.kmph_to_pps(real_speed)


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

func _sort_by_distance(a:Node2D, b:Node2D):
	var a_dist = (a.global_position - global_position).length_squared()
	var b_dist = (b.global_position - global_position).length_squared()
	
	if a_dist < b_dist:
		return true
	return false


func _check_if_player_visible(player: Node2D):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if not result:
		return false
	if not player == result.collider:
		return false
	
	return true


func get_closest_visible_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("player")
	players.sort_custom(_sort_by_distance)
	
	for player in players:
		var visible = _check_if_player_visible(player)
		if visible:
			return player
	
	return null


func got_eaten():
	queue_free()
