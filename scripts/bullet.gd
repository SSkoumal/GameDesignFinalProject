extends Area2D

@export var speed := 400.0          # pixels per second
var direction : Vector2 = Vector2.ZERO
var owner_id : String = ""          # "Player_1" or "Player_2"

func _ready() -> void:
	# Auto-delete after 3 s so bullets don’t pile up
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		if body.owner_id != owner_id:  
			# only hurt the other player’s enemy
			body.take_damage()		
			queue_free()
		
