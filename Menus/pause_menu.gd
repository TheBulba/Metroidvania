extends ColorRect

var paused = false

func set_paused(value):
	paused = value
	get_tree().paused = paused
	visible = paused
	if paused:
		SoundFx.play("Pause", 1, -10)
	else:
		SoundFx.play("Unpause", 1, -10)
	
func _process(delta):
	var player_is_alive =  get_tree().get_nodes_in_group("Player").size() > 0
	if Input.is_action_just_pressed("pause") and player_is_alive:
		self.paused = !paused  
		set_paused(paused)

func _on_resume_pressed():
	SoundFx.play("Click", 1, -10)
	set_paused(false)

func _on_quit_pressed():
	SoundFx.play("Click", 1, -10)
	get_tree().quit()
