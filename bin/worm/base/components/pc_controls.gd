class_name PCControls extends Node


@onready var worm:Worm = get_parent()
@onready var state_chart:StateChart = $"../StateChart"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("boost"):
		state_chart.send_event("boost")
	
	if event.is_action_released("boost"):
		state_chart.send_event("boost_off")
	
	if event.is_action_pressed("stop_moving"):
		state_chart.send_event("stop_moving")
	
	if event.is_action_released("stop_moving"):
		state_chart.send_event("start_moving")
