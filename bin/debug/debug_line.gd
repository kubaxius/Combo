class_name DebugLine extends Node2D

var from: Vector2
var to: Vector2
var lifetime: float
var fade: bool
var color: Color
var width: float


func _ready() -> void:
	if lifetime > 0:
		$RemoveTimer.start(lifetime)
	
	Debug.debug_mode_changed.connect(_debug_state_changed)
	
	if not fade:
		set_process(false)


func _process(_delta: float) -> void:
	var time_scale = $RemoveTimer.time_left/lifetime
	modulate.a = time_scale
	scale = Vector2(time_scale, time_scale)


func _draw() -> void:
	draw_line(from, to, color, width)


func _remove():
	queue_free()


func _debug_state_changed(value):
	visible = value
