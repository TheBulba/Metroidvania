extends Node2D

const WORLD = preload("res://Scenes/world.gd")

func _ready():
	var parent = get_parent()
	if parent is WORLD:
		parent.currentLevel = self

func save():
	var save_dictionary = {
	"filename" : get_scene_file_path(),
	"parent": get_parent().get_path(),	
	"position_x" : position.x,
	"position_y" : position.y
	}
	return save_dictionary
