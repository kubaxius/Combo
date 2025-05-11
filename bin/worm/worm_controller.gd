class_name WormController extends Node2D

@onready var head: WormHead = %Head
@onready var segments_container: WormSegmentsContainer = %SegmentsContainer

signal docked
signal left_dock

var velocity: Vector2:
	get():
		return $Head.velocity


func dock():
	docked.emit()


func undock():
	left_dock.emit()
