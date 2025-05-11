@icon("res://editor_icons/collision_reaction_character.svg")
class_name CollisionReactionCharacter2DComponent extends CollisionReactionComponent


@onready var actor: CharacterBody2D = $".."
@export_custom(PROPERTY_HINT_NONE, "suffix:t") var mass := 10.


func _physics_process(delta: float) -> void:
	handle_slide_collisions()
	super(delta)


func handle_slide_collisions():
	for i in range(0, actor.get_slide_collision_count()):
		var collision := actor.get_slide_collision(i)
		var collider := collision.get_collider()
		
		var other_crc = Utils.get_child_of_type(collider, CollisionReactionComponent)
		if other_crc:
			on_collision(collider, collision)
			other_crc.on_collision(actor, collision)
			set_collision_as_handled(other_crc, collider)


func on_collision(other: CollisionObject2D, collision: KinematicCollision2D):
	if not should_collide(other):
		return
	
	if other is CharacterBody2D:
		handle_collision_from_character(other, collision)
	if other is RigidBody2D:
		handle_collision_from_rigid(other, collision)


func handle_collision_from_rigid(other: RigidBody2D, collision: KinematicCollision2D):
	var normal = collision.get_normal()
	
	var new_vel = calculate_my_reaction(actor.velocity, mass, other.linear_velocity, other.mass, normal)
	
	actor.velocity = new_vel


func handle_collision_from_character(other: CharacterBody2D, collision: KinematicCollision2D):
	var other_crc: CollisionReactionComponent = Utils.get_child_of_type(other, CollisionReactionComponent)
	var normal = collision.get_normal()
	
	var new_vel = calculate_my_reaction(actor.velocity, mass, other.velocity, other_crc.mass, normal)
	
	actor.velocity = new_vel
