class_name Bullet extends CharacterBody2D


@export var lifetime = 2
@export_custom(PROPERTY_HINT_RANGE, "1,1000,1,suffix:km/h") var real_speed = 200

var speed:
	get:
		return Utils.kmph_to_pps(real_speed)
	set(val):
		real_speed = Utils.pps_to_kmph(val)
var damage := 5

@onready var direction_vector = Vector2.RIGHT.rotated(global_rotation)

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
	
	collide(collision)



# -------------------------------- #
#     Signal-connected methods     #
# -------------------------------- #

func _remove():
	queue_free()


# -------------------------------- #
#          Custom methods          #
# -------------------------------- #

func setup(spawn_point: Vector2, p_rotation: float, p_real_speed: int, p_lifetime: float):
	global_position = spawn_point
	rotation = p_rotation
	lifetime = p_lifetime


func collide(collision: KinematicCollision2D):
	if collision.get_collider().is_in_group("player"):
		deal_damage(collision.get_collider())
	
	$CollisionShape2D.disabled = true
	speed = 0


func deal_damage(player: Node2D):
	print("dealt " + str(damage) + " damage")
