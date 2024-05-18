extends "res://Scenes/projectile.gd"


func _ready():
	SoundFx.play("Bullet", randf_range(0.8, 1.1))
	set_process(false)
