#extends Node
#
#var score = 0
#
#@onready var score_label: Label = $ScoreLabel
#@onready var level_node: Node = get_parent().get_node("Level1")  # Initially Level1
#
#func add_point():
	#score += 1
	#score_label.text = str(score)
#
	#if score == 3:
		#change_level("res://scenes/Level2.tscn")
	#elif score == 6:
		#change_level("res://scenes/Level3.tscn")
#
#func change_level(new_level_path: String):
	#level_node.queue_free()  # Remove the current level
	#var new_level = load(new_level_path).instantiate()
	#get_parent().add_child(new_level)
	#level_node = new_level

extends Node

var score = 0

@onready var score_label: Label = $ScoreLabel
@onready var level_node: Node = get_parent().get_node("Level1")  # Initially Level1

@onready var enemy1: Node2D = get_parent().get_node("enemy1")
@onready var enemy2: Node2D = get_parent().get_node("enemy2")
@onready var player1: Node2D = get_parent().get_node("Player1")
@onready var player2: Node2D = get_parent().get_node("Player2")
@onready var sound_player = $AudioStreamPlayer2D

func add_point():
	score += 1
	score_label.text = str(score)

	if score == 10:
		sound_player.play()
		change_level("res://scenes/Level2.tscn")
	elif score == 20:
		sound_player.play()
		change_level("res://scenes/Level3.tscn")

func change_level(new_level_path: String):
	level_node.queue_free()  # Remove the current level

	var new_level = load(new_level_path).instantiate()
	get_parent().add_child(new_level)
	level_node = new_level

	# Teleport enemies
	enemy1.global_position = Vector2(-537, -290)
	enemy2.global_position = Vector2(447, -290)

	# Teleport players
	if is_instance_valid(player1):
		player1.global_position = Vector2(-300, 0)
	if is_instance_valid(player2):
		player2.global_position = Vector2(300, 0)

	# Reset collectibles
	var game_node = get_parent()  
	game_node.reset_collectibles()
