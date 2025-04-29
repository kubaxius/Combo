extends Node

var debug_dot_res := preload("res://debug/debug_dot.tscn")

var debug_mode := false:
	set(val):
		debug_mode = val
		debug_mode_changed.emit(debug_mode)
		print("Debug Mode: " + str(debug_mode))

signal debug_mode_changed(new_state)


# -------------------------------- #
#          Input methods           #
# -------------------------------- #

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_debug"):
		debug_mode = !debug_mode


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func draw_debug_dot(pos: Vector2, lifetime: float = 5, fade = false, color: Color = Utils.get_random_color()) -> DebugDot:
	if not debug_mode:
		return
	var debug_dot:DebugDot = debug_dot_res.instantiate()
	debug_dot.position = pos
	debug_dot.color = color
	debug_dot.lifetime = lifetime
	debug_dot.fade = fade
	get_tree().get_root().add_child(debug_dot)
	return debug_dot
