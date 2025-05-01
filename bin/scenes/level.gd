class_name Level extends Node2D

var player_spotted = false


func _ready() -> void:
	Debug.debug_mode = true


@warning_ignore("unused_parameter")
func _on_player_spotted(loc: Vector2):
	if player_spotted:
		return
	player_spotted = true
	print("You have been spotted!")
