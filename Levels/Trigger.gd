extends Area2D

signal triggered

var enabled = true

func _on_body_entered(body):
	if enabled:
		emit_signal("triggered")
		enabled = false
