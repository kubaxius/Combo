class_name PlayerDetectionArea extends Area2D

@export var underground_detector := false

signal player_entered(player)
signal player_exited(player)

func _on_body_entered(body: Node2D) -> void:
	
	if not body.is_in_group("player"):
		return
	if not "is_in_ground" in body:
		return
	if body.is_in_ground and not underground_detector:
		return
	
	player_entered.emit(body)


func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if not "is_in_ground" in body:
		return
	if body.is_in_ground and not underground_detector:
		return
	
	player_exited.emit(body)
