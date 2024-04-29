extends Resource
class_name PlayerStats

@export var max_health : int = 4
@export var max_missiles : int = 3
var health = max_health
var missiles = max_missiles
var missiles_unlocked = false

signal playerdied
signal player_missiles_unlocked(value)
signal player_health_changed(health)
signal missiles_amount_changed(amount)

func set_health(damage):
	health -= damage
	emit_signal("player_health_changed", health)
	if health == 0:
		emit_signal("playerdied")
	elif health > 0:
		Events.emit_signal("addscreenshake",0.5,0.5)

func set_missiles(value):
	missiles += value
	missiles = clamp(missiles, 0, max_missiles)
	emit_signal("missiles_amount_changed", missiles)

func set_missiles_unlock(value):
	missiles_unlocked = value
	SaverAndLoader.custom_data.MISSILES_UNLOCKED = value
	emit_signal("player_missiles_unlocked", missiles_unlocked)   

func Refill_stats():
	health = max_health
	emit_signal("player_health_changed", health)
	set_missiles(max_missiles)
