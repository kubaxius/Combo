@icon("res://components/collision_reaction/collision_reaction_rigid.svg")
class_name CollisionReactionRigid2DComponent extends CollisionReactionComponent

@onready var actor: RigidBody2D = $".."

#TODO: finish this so it can initiate collisions.

func _physics_process(delta: float) -> void:
	super(delta)


func on_collision(other: CollisionObject2D, collision: KinematicCollision2D):
	if not should_collide(other):
		return
	
	if other is CharacterBody2D:
		handle_collision_from_character(other, collision)


func handle_collision_from_character(other: CharacterBody2D, collision: KinematicCollision2D):
	var hit_position = collision.get_position() - actor.global_position
	var other_crc = Utils.get_child_of_type(other, CollisionReactionComponent)
	var other_mass = other_crc.mass
	
	var impulse = other.velocity
	# TODO: This should somehow take mass of other into consideration, since
	# apply impulse already takes the mass of RigidBody into consideration.
	# Check Rapier for this.
	actor.apply_impulse(impulse, hit_position)
