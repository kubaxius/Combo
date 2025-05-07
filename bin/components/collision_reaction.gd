class_name CollisionReactionComponent extends Component

@onready var actor: CollisionObject2D = $'..' 

var slide_collisions = false
var reaction = false

func _ready():
	if actor is CharacterBody2D:
		slide_collisions = true
		reaction = true


func _physics_process(delta: float) -> void:
	if slide_collisions:
		handle_slide_collisions()


func handle_slide_collisions():
	for i in actor.get_slide_collision_count():
		var collider = actor.get_slide_collision(i).get_collider()
		if actor.has_node("CollisionReactionComponent"):
			actor.get_node("CollisionReactionComponent").on_collision(actor)


func on_collision(collider: CollisionObject2D):
	if not reaction:
		return
	
	if 'velocity' in collider:
		actor.velocity += collider.velocity
