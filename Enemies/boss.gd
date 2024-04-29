extends "res://Enemies/enemy.gd"

var Maininstace = Resourceloader.instances
var player = Maininstace.Player
const BULLET = preload("res://Enemies/enemy_bullet.tscn")

const ACCELERATION = 70

signal died

enum {
	MOVE,
	ATTACK
}

var state = MOVE

func _ready():
	if SaverAndLoader.custom_data.BOSS_DEFEATED == true:
		queue_free()

func _physics_process(delta):
	
	match state:
		MOVE:
			chase_player(delta)
		ATTACK:
			pass
			
	move_and_slide()


func chase_player(delta):
	if player != null:
		var facing = sign(player.global_position.x - global_position.x)
		velocity.x += facing * delta * ACCELERATION
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
		rotation_degrees = lerp(rotation_degrees, (velocity.x / MAX_SPEED) * 10 , 0.3)
		
		var distance = global_position.y - player.global_position.y 
		
		if distance < -75:
			velocity.y = 40
		else:
			velocity.y = -40
		
		if $RightCheck.is_colliding() and velocity.x > 0:
			velocity.x *= -0.5
		if $LeftCheck.is_colliding() and velocity.x < 0:
			velocity.x *= -0.5
			
		
func fire_bullet() -> void:
	var bullet = Utils.instance_scene_on_main(BULLET, global_position)
	bullet.velocity = Vector2(0,1) * 50
	bullet.velocity = bullet.velocity.rotated(deg_to_rad(randf_range(-30,30)))
	
func dash_attack() -> void:
	var distance = global_position.y - player.global_position.y 
	var facing = sign(player.global_position.x - global_position.x)
	if distance < 0: 
		velocity. x = 100 * facing
		velocity.y = 200
	$Finish.start()

func _on_timer_timeout():
	fire_bullet()

func _on_dash_timeout():
	state = ATTACK
	dash_attack()

func _on_finish_timeout():
	self.position = Vector2(75, 0)
	state = MOVE

func _on_enemy_stats_enemydied():
	emit_signal("died")
	SaverAndLoader.custom_data.BOSS_DEFEATED = true
	super._on_enemy_stats_enemydied()
