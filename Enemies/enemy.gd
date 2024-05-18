extends CharacterBody2D

@export var MAX_SPEED: int = 15

@onready var stats = $EnemyStats

const DEATHEFFECT = preload("res://Effect/enemy_death_effect.tscn")

func _on_hurtbox_hit(damage):
	stats.set_health(damage)

func _on_enemy_stats_enemydied():
	SoundFx.play("EnemyDie", 1, -10)
	Utils.instance_scene_on_main(DEATHEFFECT, global_position)
	queue_free()
