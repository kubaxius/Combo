extends Node

var movement_rng = RandomNumberGenerator.new()

var debug_mode := false:
	set(val):
		debug_mode = val
		debug_mode_changed.emit(debug_mode)
		print("Debug Mode: " + str(debug_mode))

signal debug_mode_changed(new_state)


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	movement_rng.randomize()


# -------------------------------- #
#          Input methods           #
# -------------------------------- #

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		debug_mode = !debug_mode
