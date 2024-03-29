extends Node

func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instantiate() 
	main.add_child(instance)
	instance.global_position = position
	return instance
