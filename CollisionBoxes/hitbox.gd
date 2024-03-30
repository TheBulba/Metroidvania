extends Area2D

@export var damage: int = 1

func _on_area_entered(hurtbox):
	hurtbox.emit_signal("hit", damage)
