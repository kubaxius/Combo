@tool
@icon("res://addons/beehave/icons/tree.svg")
class_name SoldierAI extends BeehaveTree


func _ready() -> void:
	delay_enable()
	if get_tree().get_root().has_node("Level"):
		blackboard.set_value("level", get_tree().get_root().get_node("Level"))
	
	super()


func delay_enable():
	var timer := get_tree().create_timer(0.3)
	timer.timeout.connect(enable)
