extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var ammo: int = 6
const BULLET_SCENE := preload("res://scenes/bullet.tscn")
var shoot_cooldown := 0.25
var _shoot_timer := 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump2") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	# Get the input direction: -1, 0, 1
	var direction = Input.get_axis("move_left_2", "move_right_2")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# --- Shooting Timer Countdown ---
	_shoot_timer = max(0.0, _shoot_timer - delta)

# --- Shoot input (Down arrow) ---
	var shoot_dir = Vector2(
		Input.get_action_strength("aim_right_2") - Input.get_action_strength("aim_left_2"),
		Input.get_action_strength("aim_down_2") - Input.get_action_strength("aim_up_2")
	)
	
	if shoot_dir != Vector2.ZERO and Input.is_action_pressed("shoot_2"):
		if _shoot_timer == 0 and ammo > 0:
			_shoot_timer = shoot_cooldown
			_spawn_bullet(shoot_dir.normalized())
	move_and_slide()
	
func _spawn_bullet(dir: Vector2) -> void:
	var bullet = BULLET_SCENE.instantiate()
	bullet.position = position
	bullet.direction = dir
	bullet.owner_id = "player_2"
	get_tree().current_scene.add_child(bullet)
	# ammo -= 1	wadw
