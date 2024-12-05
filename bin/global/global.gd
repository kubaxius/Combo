extends Node

var movement_rng = RandomNumberGenerator.new()


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	randomize()
	movement_rng.randomize()
