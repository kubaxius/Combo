class_name DebugPointer extends Marker2D

func _ready() -> void:
	visible = Debug.debug_mode
	Debug.debug_mode_changed.connect(_debug_state_changed)


func _debug_state_changed(value):
	visible = value
