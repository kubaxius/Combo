extends Node2D


@onready var worm := $Worm
@onready var worm_head: WormHead = $Worm.head

func _ready() -> void:
	worm_head.target = $HeadStop.global_position
	worm_head.controls_disabled = true


func _on_worm_reached_stop():
	worm.docked($DockPath)
