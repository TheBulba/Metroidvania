extends "res://Scenes/projectile.gd"

const EFFECT = preload("res://Effect/enemy_death_effect.tscn")

const BRICK_LAYER_BIT =  18

func _on_hitbox_body_entered(_body):
	if _body.get_collision_layer() == BRICK_LAYER_BIT:
		_body.queue_free()
		Utils.instance_scene_on_main(EFFECT, _body.global_position + Vector2(8,8 ))
	super._on_hitbox_body_entered(_body)
