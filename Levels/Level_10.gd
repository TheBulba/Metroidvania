extends "res://Levels/level.gd"

@onready var boss = $Boss
@onready var blocked_door = $BlockDoor

func _ready():
	blocked_door.visible = false

func _on_trigger_triggered():
	if SaverAndLoader.custom_data.BOSS_DEFEATED == false: 
		blocked_door.visible = true 
		blocked_door.position.y += 32


func _on_boss_died():
	blocked_door.visible = false 
	blocked_door.position.y -= 32
