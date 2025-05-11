extends Node2D


@onready var worm: WormController = $Worm
@onready var worm_head: WormHead = worm.head
@onready var worm_segments: WormSegmentsContainer = worm.segments_container

func _ready() -> void:
	worm_head.target = $HeadStopDocked.global_position
	worm_head.controls_disabled = true
	worm_head.target_reached.connect(_on_worm_reached_stop)


func _on_worm_reached_stop(pos: Vector2):
	if pos == $HeadStopDocked.global_position:
		worm_segments.dock_path = $DockPath.curve
		worm.dock()
