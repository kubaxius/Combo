extends Node

var movement_rng = RandomNumberGenerator.new()


# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	movement_rng.randomize()