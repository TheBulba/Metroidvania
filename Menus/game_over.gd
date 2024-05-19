extends CenterContainer


func _on_respawn_pressed():
	SoundFx.play("Click", 1 , -5)
	SaverAndLoader.is_loading = true
	Music._list_stop()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_quit_pressed():
	get_tree().quit()
