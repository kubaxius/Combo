class_name CollisionReactionComponent extends Component

const COLLISION_TIMEOUT := 0.2

@export var reaction := true
@export_custom(PROPERTY_HINT_NONE, "suffix:kg") var mass := 100.

@onready var actor: CollisionObject2D = $'..' 

var slide_collisions := false


var collision_cooldowns := {}



func _ready():
	if actor is CharacterBody2D:
		slide_collisions = true


func _physics_process(delta: float) -> void:
	if slide_collisions:
		handle_slide_collisions(actor)
	
	for key in collision_cooldowns.keys():
		collision_cooldowns[key] -= delta
		if collision_cooldowns[key] <= 0:
			collision_cooldowns.erase(key)
	

func handle_slide_collisions(slide_actor: CharacterBody2D):
	for i in range(0, slide_actor.get_slide_collision_count()):
		var collision := slide_actor.get_slide_collision(i)
		var collider := collision.get_collider()
		
		if collider.has_node("CollisionReactionComponent"):
			on_collision(collider, collision)
			collider.get_node("CollisionReactionComponent").on_collision(slide_actor, collision)


func on_collision(other: CollisionObject2D, collision: KinematicCollision2D):
	var collider := collision.get_collider()
	if collider in collision_cooldowns:
		return
	
	if not reaction:
		return
	
	if actor is CharacterBody2D and other is RigidBody2D:
		character_from_rigid(other, collision)
	elif actor is CharacterBody2D and other is CharacterBody2D:
		character_from_character(other, collision)
	elif actor is RigidBody2D and other is RigidBody2D:
		rigid_from_rigid(other, collision)
	elif actor is RigidBody2D and other is CharacterBody2D:
		rigid_from_character(other, collision)
	
	collision_cooldowns[collider] = COLLISION_TIMEOUT


func character_from_rigid(other: RigidBody2D, collision: KinematicCollision2D):
	pass


func character_from_character(other: CharacterBody2D, collision: KinematicCollision2D):
	var restitution = 0.8
	var other_crc: CollisionReactionComponent = other.get_node("CollisionReactionComponent")
	
	var normal = collision.get_normal()
	
	# Project velocities onto a normal
	var vn_actor = normal.dot(actor.velocity)
	var vn_other = normal.dot(other.velocity)
	
	# Calculate new normal velocities
	var vn_actor_new = \
	(
		vn_actor * (mass - restitution * other_crc.mass) + \
		(1 + restitution) * other_crc.mass * vn_other
	) / (mass + other_crc.mass)
	
	# Tangent components remain unchanged
	var tangent = Vector2(-normal.y, normal.x)
	var vt_actor = tangent.dot(actor.velocity)

	# Combine new normal and old tangential parts
	var new_vel_actor = normal * vn_actor_new + tangent * vt_actor
	
	print(str(actor) + " - " + str(MeasurementUtils.pps_to_kmph(new_vel_actor.length())))
	actor.velocity = new_vel_actor
	
	


func rigid_from_rigid(other: RigidBody2D, collision: KinematicCollision2D):
	pass


func rigid_from_character(other: CharacterBody2D, collision: KinematicCollision2D):
	pass
