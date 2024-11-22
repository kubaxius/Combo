extends Node

@export_node_path("PhysicsBody2D") var connection_body:
	get():
		return get_node(connection_body)
