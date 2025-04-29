class_name ProjectileTrail extends Line2D

## The entire trail will vanish after this time.
@export var lifetime := 0.
## Set to zero to disable.
@export_range(0., 10., 0.1) var point_lifetime := 0.2

@export var gravity := Vector2.ZERO
@export var wildness := 3.0
@export var min_spacing := 5

var tick_speed := 0.05
var tick := 0.
var wild_speed := 0.
var point_age := []


func _ready() -> void:
	ov_add_point(get_parent().global_position)
	
	if lifetime < 0.000001:
		return
	var tween := get_tree().create_tween()
	tween\
	.tween_property(self, "modulate:a", 0., lifetime)\
	.set_trans(Tween.TRANS_CIRC)\
	.set_ease(Tween.EASE_OUT)


func _process(delta: float) -> void:
	if tick <= tick_speed:
		tick += delta
		return
	
	var point_indexes_to_remove = []
	ov_add_point(get_parent().global_position)
	for p in range(get_point_count()):
		point_age[p] += delta
		
		if point_lifetime > 0. and point_age[p] > point_lifetime:
			point_indexes_to_remove.append(p)
			continue
		
		var rand_vector = Vector2(randf_range(-wild_speed, wild_speed),\
								  randf_range(-wild_speed, wild_speed))
		points[p] += gravity
		points[p] += rand_vector * wildness * point_age[p] * 5
		
	for id in range(point_indexes_to_remove.size() -1, -1, -1):
		remove_point(id)
		point_age.remove_at(id)

func ov_add_point(pos: Vector2, index: int = -1):
	if get_point_count() > 0 and pos.distance_to(points[-1]) < min_spacing:
		return
	
	point_age.append(0.)
	add_point(pos, index)
