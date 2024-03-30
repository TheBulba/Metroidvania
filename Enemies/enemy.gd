extends CharacterBody2D

@export var MAX_SPEED: int = 15

func _on_hurtbox_hit(damage):
	queue_free()
