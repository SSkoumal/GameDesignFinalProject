extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health := 3
var heart_ui
var invincible = false


@onready var animated_sprite = $AnimatedSprite2D
func _ready():
	await get_tree().process_frame  # Wait one frame so the scene fully loads
	heart_ui = get_parent().get_node("HeartUI_Player2")
	print("Heart UI successfully loaded for Player 2:", heart_ui)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump2") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement input
	var direction = Input.get_axis("move_left_2", "move_right_2")
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Collision detection
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("enemy"):
			take_damage(collider)



func take_damage(enemy: CharacterBody2D = null):
	if invincible:
		print("Player is invincible — no damage")
		return

	invincible = true
	health -= 1
	print("Player took damage! Health:", health)

	if heart_ui:
		heart_ui.update_hearts(health)

	var found_enemies = get_tree().get_nodes_in_group("enemy")
	print("Found enemies in group:", found_enemies.size())

	# Custom wreset for each enemy
	# Reset all enemies to their spots
	for e in get_tree().get_nodes_in_group("enemy"):
		print("Resetting enemy:", e.name)

		match e.name:
			"enemy1":
				print("enemy1 -> (537, -290)")
				e.global_position = Vector2(537, -290)
			"enemy2":
				print("enemy2 -> (-447, -290)")
				e.global_position = Vector2(-447, -290)
			_:
				print(e.name, "-> (20, 20)")
				e.global_position = Vector2(20, 20)

		e.velocity = Vector2.ZERO
		e.can_chase = false
		e.velocity = Vector2(0, -100)

		var this_enemy = e
		var timer := get_tree().create_timer(1.0)
		timer.timeout.connect(func():
			print(this_enemy.name, "can now chase again")
			this_enemy.can_chase = true
		)


	if health <= 0:
		die()
		return
	else:
		await get_tree().create_timer(0.5).timeout
		invincible = false
		print("Player is now vulnerable again")




func die():
	print("Player 2 Died!")
	queue_free()
