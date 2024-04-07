extends Node2D


var motion = Vector2(randf_range(-20,20), randf_range(-10,-40))

func _process(delta):
	position += motion * delta


func _on_dust_effect_9_tree_exited():
	pass # Replace with function body.
