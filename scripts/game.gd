extends Node2D

var collectible_scene = preload("res://scenes/collectible.tscn")
@onready var game_manager = $GameManager  # Adjust this if GameManager is elsewhere

const MAX_COLLECTIBLES = 10
var spawn_timer = 1.0  # seconds
var time_accumulator = 0.0

func _ready():
	randomize()
	_spawn_collectibles(MAX_COLLECTIBLES)  # Spawn 10 at the start

func _process(delta):
	time_accumulator += delta
	if time_accumulator >= spawn_timer:
		time_accumulator = 0.0
		_check_and_spawn()

func _check_and_spawn():
	var current_collectibles = get_tree().get_nodes_in_group("collectibles")
	var missing = MAX_COLLECTIBLES - current_collectibles.size()
	if missing > 0:
		_spawn_collectibles(missing)

func _spawn_collectibles(amount):
	for i in range(amount):
		var coin = collectible_scene.instantiate()
		coin.global_position = Vector2(randf_range(-550, 550), randf_range(-300, 300))
		coin.game_manager = game_manager  # Pass the reference manually!
		coin.add_to_group("collectibles")  # So we can easily count them later
		add_child(coin)
		
func reset_collectibles():
	# Remove all existing collectibles
	for node in get_tree().get_nodes_in_group("collectibles"):
		node.queue_free()

	time_accumulator = 0.0
	_spawn_collectibles(MAX_COLLECTIBLES)
