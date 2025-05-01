extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var target_to_chase: CharacterBody2D
@export var can_chase: bool = true


const SPEED = 120.0
var start_position: Vector2

func _ready():
	start_position = global_position


func reset():
	print("Enemy reset triggered")
	can_chase = false
	global_position = start_position
	velocity = Vector2.ZERO
	print("Enemy reset — waiting...")

	var timer := get_tree().create_timer(1.0)
	timer.timeout.connect(func():
		print("Enemy ready to chase again")
		can_chase = true
	)



func _physics_process(delta: float) -> void:
	if not can_chase:
		return

	if not is_instance_valid(target_to_chase):
		print("Target player no longer exists. Stopping chase.")
		return

	navigation_agent.target_position = target_to_chase.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED
	move_and_slide()
	
	
