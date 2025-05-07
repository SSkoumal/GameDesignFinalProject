extends Control

@onready var hearts := $HBoxContainer.get_children()

func update_hearts(health: int):
	for i in range(hearts.size()):
		hearts[i].visible = i < health
