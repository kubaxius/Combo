class_name Level extends Node2D

var player_spotted = false


func _ready() -> void:
	Debug.debug_mode = false


# HACK: You have to find a better way.
var elapsed_time = 0.
func _physics_process(delta: float) -> void:
	elapsed_time += delta
	return


func _on_player_spotted(_loc: Vector2):
	if player_spotted:
		return
	if elapsed_time < 1.:
		return
	
	player_spotted = true
	set_physics_process(false)
	print("You have been spotted!")
