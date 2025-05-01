extends Node

@onready var debug_draw_space = Sprite2D.new()

var debug_dot_res := preload("res://debug/debug_dot.tscn")
var debug_line_res := preload("res://debug/debug_line.tscn")

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
	get_tree().get_root().add_child.call_deferred(debug_draw_space)


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
	debug_draw_space.add_child(debug_dot)
	return debug_dot


func draw_debug_line(from: Vector2, to: Vector2, width: float = 3, lifetime: float = 5, fade = false, color: Color = Utils.get_random_color()):
	if not debug_mode:
		return
	var debug_line:DebugLine = debug_line_res.instantiate()
	debug_line.from = from
	debug_line.to = to
	debug_line.color = color
	debug_line.width = width
	debug_line.lifetime = lifetime
	debug_line.fade = fade
	debug_draw_space.add_child(debug_line)
	return debug_line
