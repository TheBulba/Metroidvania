extends CharacterBody2D

@export var MAX_SPEED: int = 15

@onready var stats = $EnemyStats

func _on_hurtbox_hit(damage):
	stats.set_health(damage)

func _on_enemy_stats_enemydied():
	queue_free()
