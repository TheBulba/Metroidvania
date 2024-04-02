extends Node2D

var velocity = Vector2.ZERO
const ExplosionEffect = preload("res://Effect/explosion_effect.tscn")

func _process(delta):
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_hitbox_body_entered(_body):
	Utils.instance_scene_on_main(ExplosionEffect, global_position)
	queue_free()


func _on_hitbox_area_entered(_area):
	Utils.instance_scene_on_main(ExplosionEffect, global_position)
	queue_free()
