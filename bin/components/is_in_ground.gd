@icon("res://components/component_icon_2d.svg")
class_name IsInGroundComponent extends Marker2D

## If true, the component will check if it's in ground every frame, and will
## send a signal if the state changed. Otherwise, you will
## have to check manually, by invoking the is_in_ground() method.
@export var reactive = true

enum {GROUNDED, AIRBORN}

var ground_state = GROUNDED

signal ground_entered
signal ground_exited
signal ground_state_changed(new_state: int)


func _ready() -> void:
	set_physics_process(reactive)


func _physics_process(delta: float) -> void:
	reactive_check()


func reactive_check() -> void:
	if is_in_ground():
		if ground_state == GROUNDED:
			return
		ground_state = GROUNDED
		ground_entered.emit()
	else:
		if ground_state == AIRBORN:
			return
		ground_state = AIRBORN
		ground_exited.emit()
	
	ground_state_changed.emit(ground_state)


func is_in_ground() -> bool:
	var space = get_world_2d().direct_space_state
	var point = PhysicsPointQueryParameters2D.new()
	point.position = global_position
	var collisions = space.intersect_point(point)
	for collision in collisions:
		if collision.collider is Ground:
			return true
	return false
