class_name PlayerDetection extends Node2D

var player_already_detected = false
signal player_detected

# TODO: If the player enters the ground while beeing visible he will not get
# removed from the overground players
var overground_visible_players = []
var underground_visible_players = []


# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _on_player_entered(player):
	if not player_already_detected:
		player_already_detected = true
		player_detected.emit()


func _on_overground_player_entered(player):
	overground_visible_players.append(player)


func _on_overground_player_exited(player):
	overground_visible_players.erase(player)


func _on_underground_player_entered(player):
	underground_visible_players.append(player)


func _on_underground_player_exited(player):
	underground_visible_players.erase(player)
