extends Area2D

var game_manager  # No @onready here, it's assigned manually!

func _on_body_entered(body: Node2D) -> void:
	if game_manager != null:
		game_manager.add_point()
	queue_free()
