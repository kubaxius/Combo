@icon("res://components/component_icon_2d.svg")
class_name LookAtMouseComponent extends Node2D

## Angle from X axis. [br][br]
## 0° - positive X (right) [br]
## 90° - negative Y (up) [br]
## 180° - negative X (left) [br]
## 270° - positive Y (down)
@export_range(0, 360, 90, "radians_as_degrees") var facing_angle := 0.
@export var enabled := true

@onready var actor:Node2D = $'..'


func _ready() -> void:
	set_physics_process(enabled)

func _physics_process(delta: float) -> void:
	make_actor_look_at_mouse()


func make_actor_look_at_mouse():
	actor.look_at(get_global_mouse_position())
	actor.rotate(facing_angle)
