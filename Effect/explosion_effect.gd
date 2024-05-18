extends Node2D


func _ready():
	SoundFx.play("Explosion", randf_range(0.6, 1.0))
