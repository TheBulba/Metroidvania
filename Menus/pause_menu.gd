extends ColorRect

var paused = false

func set_paused(value):
	paused = value
	get_tree().paused = paused
	visible = paused
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		self.paused = !paused 
		set_paused(paused)

func _on_resume_pressed():
	set_paused(false)


func _on_respawn_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()
