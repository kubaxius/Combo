extends Node2D


@onready var worm := $Worm


func _ready() -> void:
	worm.destination_reached.connect(_on_worm_reached_stop)


func _on_worm_reached_stop():
	worm.docked($DockPath)
