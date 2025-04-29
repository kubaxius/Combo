class_name Bullet extends CharacterBody2D

var real_speed = 100
var speed:
	get:
		return Utils.kmph_to_pps(real_speed)
var damage := 5
var lifetime = 2
@onready var direction_vector = Vector2.RIGHT.rotated(global_rotation)

#TODO: Make particles stay in place and slowly vanish instead of
# having position relative to bullet and shoot in the other way.
# Use this: https://www.youtube.com/watch?v=bqyDm0MmGqg

# -------------------------------- #
#         Built-in methods         #
# -------------------------------- #

func _ready() -> void:
	if lifetime > 0:
		$RemoveTimer.start(lifetime)


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(direction_vector * speed * delta)
	
	if not collision:
		return
	
	if collision.get_collider().is_in_group("player"):
		deal_damage(collision.get_collider())
	
	$Sprite2D.hide()
	$GPUParticles2D.one_shot = true
	real_speed = 0



# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _remove():
	queue_free()


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func _setup_particle_trail():
	var particle_mat: ParticleProcessMaterial = $GPUParticles2D.process_material
	particle_mat.initial_velocity_min = -speed
	particle_mat.initial_velocity_max = -speed


func setup(p_rotation: float, p_real_speed: int, p_lifetime: float):
	rotation = p_rotation
	real_speed = p_real_speed
	lifetime = p_lifetime
	#_setup_particle_trail()


func deal_damage(player: Node2D):
	print("dealt " + str(damage) + " damage")
