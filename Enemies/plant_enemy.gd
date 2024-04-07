extends "res://Enemies/enemy.gd"

@export var bullet_speed : int = 30
@export var spread : float =  45

const BULLET = preload("res://Enemies/enemy_bullet.tscn")

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	$AnimationPlayer.play("plop")
	
func fire_bullet():
	var bullet = Utils.instance_scene_on_main(BULLET, $Spawn.global_position)
	var direction = ($Direction.global_position - global_position).normalized()
	direction = direction.rotated(deg_to_rad(randf_range(-spread,spread)))
	bullet.velocity = direction * bullet_speed

func _on_visible_on_screen_notifier_2d_screen_entered():
	set_physics_process(true)


func _on_visible_on_screen_notifier_2d_screen_exited():
	set_physics_process(false)
