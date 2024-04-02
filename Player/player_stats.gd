extends Resource
class_name PlayerStats

@export var max_health : int = 4
var health = max_health

func set_health(damage):
	health -= damage
	if health == 0:
		emit_signal("playerdied")
	
signal playerdied
