extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var health := 3

@onready var animated_sprite = $AnimatedSprite2D
@onready var heart_ui = get_node("/root/Game/HeartUI_Player1")

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
			take_damage()
			collider.queue_free()

func take_damage():
	health -= 1
	heart_ui.update_hearts(health)
	print("Player 2 took damage! Health:", health)
	if health <= 0:
		die()

func die():
	print("Player 2 Died!")
	queue_free()
