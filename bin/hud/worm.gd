class_name WormHud extends Control

@onready var speedometer = $Speedometer


func _ready() -> void:
	var worm:Worm = get_tree().get_first_node_in_group("worm")
	#worm.current_speed_changed.connect(speedometer.set_speed)
	#speedometer.max_value = Utils.pps_to_kmph(worm.max_speed)
