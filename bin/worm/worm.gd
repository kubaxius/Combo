class_name Worm extends Node2D

@export_range(1, 100) var speed = 10

func _ready() -> void:
	add_part(load("res://worm/heads/basic_head.tscn"))
	add_part(load("res://worm/parts/basic_part.tscn"))

func add_part(part_res:Resource):
	var part:WormPart = part_res.instantiate()
	$Body.add_child(part)
	part.setup(0, speed, $WormPath2D)
