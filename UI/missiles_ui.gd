extends Control


var Playerstats = Resourceloader.playerstats

@onready var lable = $HBoxContainer/Label

func _ready():
	Playerstats.missiles_amount_changed.connect(_missiles_amount_changed)

func _missiles_amount_changed(amount):
	lable.text = str(amount)
