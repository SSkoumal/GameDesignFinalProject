
extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	#Engine.time_scale = 0.5
	Engine.time_scale = 1
	print("test killarea")
	#body.get_node("CollisionShape2D").queue_free()
	timer.start()
	if body.has_method("take_damage"):
		body.take_damage(null)
		queue_free() # optional: the killarea destroys itself on use
	
#func _on_timer_timeout() -> void:
	#Engine.time_scale = 1
	#get_tree().reload_current_scene()
