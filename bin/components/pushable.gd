class_name PushableComponent extends Node

@onready var actor: CharacterBody2D = get_parent()

# TODO
func calculate():
	var collision_count = get_parent().get_slide_collision_count()
	
	for i in range(0, collision_count):
		var collision := actor.get_slide_collision(i)
		if collision.get_collider():
			if "velocity" in collision.get_collider():
				print(collision.get_collider().velocity)
