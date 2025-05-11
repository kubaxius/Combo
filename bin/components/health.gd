@icon("res://editor_icons/health.svg")
class_name HealthComponent extends Component


@export var max_health := 100
## This value will be subtracted from every attack damage.
@export var armor := 0

@onready var health := max_health

signal damage_taken(amount: int)
signal health_reached_zero


## Returns inflicted damage.
func damage(amount: int, _damager: Node) -> int:
	var inflicted_damage = clamp(amount - armor, 0, amount)
	health -= inflicted_damage
	damage_taken.emit(inflicted_damage)
	
	if health <= 0:
		health = 0
		health_reached_zero.emit()
	
	return inflicted_damage


func heal(amount: int, _healer: Node):
	health += amount
	health = clamp(health, 0, max_health)
