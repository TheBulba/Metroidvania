extends Control


var Playerstats = Resourceloader.playerstats

@onready var lable = $HBoxContainer/Label

func _ready():
	Playerstats.missiles_amount_changed.connect(_missiles_amount_changed)
	Playerstats.player_missiles_unlocked.connect(_player_missiles_unlocked)

func _missiles_amount_changed(amount):
	lable.text = str(amount)

func _player_missiles_unlocked(value):
	visible = value
