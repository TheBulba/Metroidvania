extends Node

signal enemydied

@export var max_health :int = 1

@onready var health = max_health

func set_health(damage):
	health -= damage
	if health <= 0:
		emit_signal("enemydied")
