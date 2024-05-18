extends Control

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)

func _on_new_pressed():
	SoundFx.play("Click", 1 , -5)
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_load_pressed():
	SoundFx.play("Click", 1 , -5)
	SaverAndLoader.is_loading = true
	get_tree().change_scene_to_file("res://Scenes/world.tscn")


func _on_quit_pressed():
	get_tree().quit()

	
