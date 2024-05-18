extends "res://Scenes/projectile.gd"

const EFFECT = preload("res://Effect/enemy_death_effect.tscn")

const BRICK_LAYER_BIT =  18

func _ready():
	SoundFx.play("Bullet", 1, -10)

func _on_hitbox_body_entered(body):
	if body.is_in_group("Tilemap"):
		super._on_hitbox_body_entered(body)
	else:
		if body.get_collision_layer() == BRICK_LAYER_BIT: 
			body.queue_free()
			Utils.instance_scene_on_main(EFFECT, body.global_position + Vector2(8,8 ))
		super._on_hitbox_body_entered(body)
