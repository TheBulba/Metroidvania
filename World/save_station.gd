extends StaticBody2D

@onready var annimation = $SaveArea/Animation


func _on_save_area_body_entered(body):
	annimation.play("Save")
	SaverAndLoader.Save_Game()
