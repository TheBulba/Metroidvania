extends Control

var Playerstats = Resourceloader.playerstats

func _ready():
	Playerstats.player_health_changed.connect(_on_changed)

func _on_changed(health):
	print("aa")
	$Full.size.x = health * 5 + 1
