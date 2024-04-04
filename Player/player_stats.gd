extends Resource
class_name PlayerStats

@export var max_health : int = 4
var health = max_health

signal playerdied
signal player_health_changed(health)

func set_health(damage):
	health -= damage
	emit_signal("player_health_changed", health)
	if health == 0:
		emit_signal("playerdied")
	elif health > 0:
		Events.emit_signal("addscreenshake",0.5,0.5)

