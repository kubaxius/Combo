@tool
@icon("res://addons/beehave/icons/tree.svg")
class_name SoldierAI extends BeehaveTree


func _ready() -> void:
	if get_tree().get_root().has_node("Level"):
		blackboard.set_value("level", get_tree().get_root().get_node("Level"))
	
	super()
