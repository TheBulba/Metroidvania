extends Area2D

@export var connection: Resource = null
@export_file("*.tscn") var new_level_path: String = ""

var active = true

func _on_body_entered(Player):
	if active == true:
		Player.emit_signal("hit_door", self)
		active = false
