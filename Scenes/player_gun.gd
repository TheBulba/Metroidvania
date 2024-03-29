extends Node2D

func _process(_delta):
	rotation = get_parent().get_local_mouse_position().angle()
		
	if get_parent().flip_h == true:
		position.x = -1
	else:
		position.x = 1
