extends "res://Enemies/enemy.gd"

var Maininstace = Resourceloader.instances
const BULLET = preload("res://Enemies/enemy_bullet.tscn")

const ACCELERATION = 70

signal died

func _physics_process(delta):
	
	chase_player(delta)
	
	move_and_slide()

func chase_player(delta):
	var player = Maininstace.Player
	if player != null:
		var facing = sign(player.global_position.x - global_position.x)
		velocity.x += facing * delta * ACCELERATION
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		rotation_degrees = lerp(rotation_degrees, (velocity.x / MAX_SPEED) * 10 , 0.3)
		
		if $RightCheck.is_colliding() and velocity.x > 0:
			velocity.x *= -0.5
		if $LeftCheck.is_colliding() and velocity.x < 0:
			velocity.x *= -0.5

func fire_bullet() -> void:
	var bullet = Utils.instance_scene_on_main(BULLET, global_position)
	bullet.velocity = Vector2(0,1) * 50
	bullet.velocity = bullet.velocity.rotated(deg_to_rad(randf_range(-30,30)))
	print(bullet.velocity)

func _on_timer_timeout():
	fire_bullet()
