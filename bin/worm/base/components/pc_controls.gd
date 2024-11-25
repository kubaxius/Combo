class_name PCControls extends Node


@onready var worm:Worm = get_parent()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("boost"):
		worm.apply_boost()
	
	if event.is_action_released("boost"):
		worm.remove_boost()
	
	if event.is_action_pressed("stop_moving"):
		worm.stop_moving()
	
	if event.is_action_released("stop_moving"):
		worm.start_moving()
