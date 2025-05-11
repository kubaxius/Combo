extends Node2D

@export var disabled := false:
	set(val):
		if val == disabled:
			return
		if val:
			enable()
		else:
			disable()

@onready var state_chart := $StateChart

func _ready() -> void:
	var in_ground:bool = %IsInGroundComponent.is_in_ground()
	
	if in_ground:
		state_chart.send_event("entered_ground")
	else:
		state_chart.send_event("exited_ground")



# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _on_ground_entered() -> void:
	state_chart.send_event("entered_ground")


func _on_ground_exited() -> void:
	state_chart.send_event("exited_ground")


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #


func disable():
	disabled = true
	%IsInGroundComponent.reactive = false
	state_chart.send_event("disable")


func enable():
	disabled = false
	%IsInGroundComponent.reactive = true
	if %IsInGroundComponent.is_in_ground():
		state_chart.send_event("entered_ground")
	else:
		state_chart.send_event("exited_ground")
