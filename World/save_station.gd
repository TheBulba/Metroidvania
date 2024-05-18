extends StaticBody2D

@onready var annimation = $SaveArea/Animation

var player_stats = Resourceloader.playerstats

func _on_save_area_body_entered(body):
	SoundFx.play("PowerUp", 1, -10)
	annimation.play("Save")
	SaverAndLoader.Save_Game()
	player_stats.Refill_stats()
