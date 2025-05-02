@icon("res://components/component_icon_2d.svg")
class_name GroundCheckerComp extends Area2D

@export var grounded = true:
	set(val):
		grounded = val
		grounded_state_changed.emit(grounded, last_ground)

var last_ground

signal grounded_state_changed(grounded: bool, last_ground: Node2D)

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	monitoring = true
	monitorable = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D) -> void:
	last_ground = body
	grounded = true


func _on_body_exited(_body: Node2D) -> void:
	grounded = false
