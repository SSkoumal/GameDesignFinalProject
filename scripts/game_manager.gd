extends Node

var score = 0

@onready var score_label: Label = $ScoreLabel
@onready var level_node: Node = get_parent().get_node("Level1")  # Initially Level1

func add_point():
	score += 1
	score_label.text = str(score)

	if score == 3:
		change_level("res://scenes/Level2.tscn")
	elif score == 6:
		change_level("res://scenes/Level3.tscn")

func change_level(new_level_path: String):
	level_node.queue_free()  # Remove the current level
	var new_level = load(new_level_path).instantiate()
	get_parent().add_child(new_level)
	level_node = new_level
