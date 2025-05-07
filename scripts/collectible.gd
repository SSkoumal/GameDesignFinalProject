extends Area2D

var game_manager  # No @onready here, it's assigned manually!
var ammo = 3  # Starting ammo

func _on_body_entered(body: Node2D) -> void:
	if game_manager != null:
		game_manager.add_point()
	queue_free()
	

func shoot(direction: Vector2):
	if ammo > 0:
		var bullet = preload("res://scenes/bullet.tscn").instantiate()
		bullet.position = position
		bullet.direction = direction
		bullet.owner_id = get_name()  # So we know which player shot it
		get_parent().add_child(bullet)
		ammo -= 1
		

func _process(delta):
	var shoot_dir = Vector2.ZERO
	if Input.is_action_pressed("shoot"):
		if Input.is_action_pressed("ui_up"):
			shoot_dir = Vector2.UP
		elif Input.is_action_pressed("ui_down"):
			shoot_dir = Vector2.DOWN
		elif Input.is_action_pressed("ui_left"):
			shoot_dir = Vector2.LEFT
		elif Input.is_action_pressed("ui_right"):
			shoot_dir = Vector2.RIGHT

		if shoot_dir != Vector2.ZERO:
			shoot(shoot_dir)
