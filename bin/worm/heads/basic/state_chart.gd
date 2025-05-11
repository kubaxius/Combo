@tool
extends StateChart

# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _on_ground_entered() -> void:
	send_event("entered_ground")


func _on_ground_exited() -> void:
	send_event("exited_ground")
