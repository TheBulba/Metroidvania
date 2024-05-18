extends Area2D
class_name PowerUp

var playerstats = Resourceloader.playerstats

func _pickup():
	SoundFx.play("PowerUp", 1 , -15)
