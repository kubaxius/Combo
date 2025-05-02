class_name Enemy extends CharacterBody2D

@export_range(0, 2000, 5) var sight := 2000
@export_custom(PROPERTY_HINT_RANGE, "1,100,1,suffix:km/h") var real_speed := 5
var speed:
	get():
		return Utils.kmph_to_pps(real_speed)

@export_range(0, 10, 0.1) var running_speed_mult := 2.

signal player_spotted(location: Vector2)

# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	if not get_tree().get_root().has_node("Level"):
		return
	
	var level:Level = get_tree().get_root().get_node("Level")
	player_spotted.connect(level._on_player_spotted)


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


## Casts a ray in the specified direction and returns first player it hits.
## Otherwise returns null.
func get_closest_player_in_line(pos: Vector2):
	var space_state = get_world_2d().direct_space_state
	var ray_from = global_position
	var ray_to = global_position.direction_to(pos) * sight
	var query = PhysicsRayQueryParameters2D.create(ray_from, ray_to)
	query.exclude = [self]
	var result := space_state.intersect_ray(query)
	
	if not result:
		return null
	if not result.collider.is_in_group("player"):
		return false
	
	return result.collider


func is_node_visible(node: Node2D):
	var space_state = get_world_2d().direct_space_state
	var ray_from = global_position
	var ray_to = global_position.direction_to(node.global_position) * sight
	var query = PhysicsRayQueryParameters2D.create(ray_from, ray_to)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	
	if not result:
		return false
	if not node == result.collider:
		return false
	
	return true


# TODO: I think when worm is too far away, the ground blocks closest worm part,
# which blocks the next one, which blocks the next one, and that goes all the way.
# Try excluding all enemies from the raycast, and returning the enemy as a valid
# target if there is no collision, or something like this.
func get_closest_visible_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("player")
	players.sort_custom(_sort_by_distance)
	
	for player:Node2D in players:
		var visible_player_in_line = get_closest_player_in_line(player.global_position)
		if visible_player_in_line:
			player_spotted.emit(player.global_position)
			#player.modulate = Color.RED
			return player
		#player.modulate = Color.WHITE
	return null


func is_player_visible() -> bool:
	var player = get_closest_visible_player()
	if player:
		return true
	return false


func got_eaten():
	pass#queue_free()
