class_name DebugDot extends Marker2D

var color: Color 
var lifetime: float
var fade: bool

func _ready() -> void:
	$Ellipse.fill_color = color
	
	if lifetime > 0:
		$RemoveTimer.start(lifetime)
	
	Debug.debug_mode_changed.connect(_debug_state_changed)
	
	if not fade:
		set_process(false)


func _process(_delta: float) -> void:
	var time_scale = $RemoveTimer.time_left/lifetime
	modulate.a = time_scale
	scale = Vector2(time_scale, time_scale)


func _remove():
	queue_free()


func _debug_state_changed(value):
	visible = value
