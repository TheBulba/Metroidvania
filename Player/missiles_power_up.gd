extends PowerUp

func _ready():
	if SaverAndLoader.custom_data.MISSILES_UNLOCKED == true:
		queue_free()

func _pickup():
	if playerstats.missiles_unlocked == false:
		playerstats.set_missiles_unlock(true)
	else:
		playerstats.set_missiles(playerstats.max_missiles)
	queue_free()
