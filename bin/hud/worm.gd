class_name WormHud extends Control

@onready var speedometer = $Speedometer
@onready var worm_controller: WormController =\
	get_tree().get_first_node_in_group("worm_controller")


func _physics_process(_delta: float) -> void:
	$Speedometer.set_speed(worm_controller.velocity.length())
