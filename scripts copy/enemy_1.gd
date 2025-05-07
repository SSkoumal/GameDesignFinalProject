extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D

const SPEED = 120.0

# --- New for shooting system ---
var owner_id = "player_1"   # or "Player_2" for enemy_2.gd
var health = 1

func _ready():
	add_to_group("enemy")

func _physics_process(delta: float) -> void:
	navigation_agent.target_position = target_to_chase.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED
	move_and_slide()

func take_damage():
	health -= 1
	if health <= 0:
		queue_free()
