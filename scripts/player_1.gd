extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health := 3
var heart_ui
var invincible = false

var ammo: int = 100
const BULLET_SCENE := preload("res://scenes/bullet.tscn")
var shoot_cooldown := 0.25
var _shoot_timer := 0.0

var gravity2 = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
func _ready():
	await get_tree().process_frame  # Wait one frame so the scene fully loads
	heart_ui = get_parent().get_node("HeartUI_Player1")
	print("Heart UI successfully loaded for Player 1:", heart_ui)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Jumping
	if Input.is_action_just_pressed("jump1") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movement input
	var direction = Input.get_axis("move_left_1", "move_right_1")
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	_shoot_timer = max(0.0, _shoot_timer - delta)

	var shoot_dir = Vector2(
		Input.get_action_strength("aim_right_1") - Input.get_action_strength("aim_left_1"),
		Input.get_action_strength("aim_down_1") - Input.get_action_strength("aim_up_1")
	)
	
	if shoot_dir != Vector2.ZERO and Input.is_action_pressed("shoot_1"):
		if _shoot_timer == 0 and ammo > 0:
			_shoot_timer = shoot_cooldown
			_spawn_bullet(shoot_dir.normalized())
	move_and_slide()

	# Collision detection
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("enemy"):
			take_damage(collider)


func _spawn_bullet(dir: Vector2) -> void:
	var bullet = BULLET_SCENE.instantiate()
	bullet.position = position
	bullet.direction = dir
	bullet.owner_id = "player_1"
	get_tree().current_scene.add_child(bullet)

func take_damage(enemy: CharacterBody2D = null):
	if invincible:
		print("Player is invincible — no damage")
		return

	invincible = true
	health -= 1
	print("Player took damage! Health:", health)
	
	
	if heart_ui:
		heart_ui.update_hearts(health)

	# Custom reset for each enemy
	# Reset all enemies to their spots
	
	var found_enemies = get_tree().get_nodes_in_group("enemy")
	print("Found enemies in group:", found_enemies.size())

	for e in get_tree().get_nodes_in_group("enemy"):
		print("Resetting enemy:", e.name)

		match e.name:
			"enemy1":
				print("enemy1 -> (-537, -290)")
				e.global_position = Vector2(-537, -290)
			"enemy2":
				print("enemy2 -> (447, -290)")
				e.global_position = Vector2(447, -290)
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
	print("Player 1 Died!")
	queue_free()
