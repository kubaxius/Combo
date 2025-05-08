class_name CollisionReactionComponent extends Component
## This component handles all of the physical reactions that the body might
## have to other bodies smashing into it. It only works if both bodies have
## CollisionReactionComponent, and each of the CRCs handles collision for it's
## own parent.
## TODO: Break it up into two different classes, one for CharacterBodies,
## one for RigidBodies

const COLLISION_TIMEOUT := 0.2

@export var react := true


var collision_cooldowns := {}


func _physics_process(delta: float) -> void:
	update_collision_cooldowns(delta)


## Calculates velocity of a body after a collision. It only cares about
## the velocity of the first body, and that's the one it returns.
func calculate_my_reaction(my_vel: Vector2, my_mass: float,
						 other_vel: Vector2, other_mass: float,
						 normal: Vector2, restitution := 0.8) -> Vector2:
	
	# Project velocities onto a collision normal
	var my_vn = normal.dot(my_vel)
	var other_vn = normal.dot(other_vel)
	
	# Calculate normal velocities after the collision
	var my_vn_new = \
	(
		my_vn * (my_mass - restitution * other_mass) + \
		(1 + restitution) * other_mass * other_vn
	) / (my_mass + other_mass)
	
	# Tangent components remain unchanged
	var tangent = Vector2(-normal.y, normal.x)
	var my_vt = tangent.dot(my_vel)

	# Combine new normal and old tangential parts
	var my_new_vel = normal * my_vn_new + tangent * my_vt
	
	return my_new_vel


func update_collision_cooldowns(delta: float):
	for key in collision_cooldowns.keys():
		collision_cooldowns[key] -= delta
		if collision_cooldowns[key] <= 0:
			collision_cooldowns.erase(key)


## This makes sure that even if both bodies detect collision, that it will
## be handled only one time.
func set_collision_as_handled(other_crc: CollisionReactionComponent,
							  collider: CollisionObject2D):
	self.collision_cooldowns[collider] = COLLISION_TIMEOUT
	other_crc.collision_cooldowns[collider] = COLLISION_TIMEOUT


func should_collide(other: CollisionObject2D) -> bool:
	if other in collision_cooldowns:
		return false
	
	if not react:
		return false
	
	return true


func on_collision(other: CollisionObject2D, collision: KinematicCollision2D):
	return
