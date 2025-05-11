class_name WormController extends Node2D

@onready var head: WormHead = %Head

var velocity: Vector2:
	get():
		return $Head.velocity
