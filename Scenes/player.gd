extends CharacterBody2D

#note if anything breaks remove floor_snap

const DUST_EFFECT = preload("res://Effect/dust_effect.tscn")
const PLAYER_BULLET = preload("res://Scenes/player_bullet.tscn")
const SPEED = 256
const MAX_SPEED = 64 
const FRICTION = 0.25
const GRAVITY = 200
const JUMP_FORCE = 128.0
const BULLET_SPEED = 200

var jumpwindow = true
var jumping = false

func _physics_process(delta):
	
	var x = get_input()
	horizontal_velocity(x, delta)
	gravity(delta)
	jump()
	coyote_jump()
	get_animation(x)
	
	floor_snap_length = 2
	move_and_slide()
	
	#shooting
	if Input.is_action_pressed("shoot") and $BulletTimer.time_left == 0: 
		shoot()
		$BulletTimer.start()
	
	#Absolute mess which i don't understand why it works
	if is_on_floor():
		jumping = false
		jumpwindow = true
	elif jumping == false and jumpwindow == true and !is_on_floor() :
		jumpwindow = false
		$Coyote.start()
		
	# For Future Debugging
	#print(jumping)
	#print($Coyote.time_left)
func get_input():
	var x = Input.get_axis("ui_left", "ui_right")
	return x

func horizontal_velocity(x, delta):
	if x != 0:
		velocity.x += x * SPEED * delta
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	elif x == 0 and is_on_floor():
		velocity.x = lerp(velocity.x, 0.0, FRICTION)
		
func gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = min(velocity.y, JUMP_FORCE)
		
func jump():
		if is_on_floor() and Input.is_action_just_pressed("ui_up"): 
			velocity.y = -JUMP_FORCE
			jumping = true	
		elif Input.is_action_just_released("ui_up") and velocity.y < -JUMP_FORCE/2:
			velocity.y = -JUMP_FORCE/2
			
func coyote_jump():		
	if !is_on_floor() and $Coyote.time_left > 0 and jumping == false:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -JUMP_FORCE
			jumping = true
			
func get_animation(x):
	
	
	$Player.scale.x = sign(get_local_mouse_position().x)
	
	if x != 0:
		$Sprite_Animator.play("Run")
		$Sprite_Animator.speed_scale = x * $Player.scale.x
	else:
		$Sprite_Animator.speed_scale = 1.0
		$Sprite_Animator.play("Idle")	
	
	if !is_on_floor():
		$Sprite_Animator.play("Jump")

func shoot():
	var bullet = Utils.instance_scene_on_main(PLAYER_BULLET, $Player/PlayerGun/PlayerGun/Muzzle.global_position)
	bullet.velocity = Vector2.RIGHT.rotated($Player/PlayerGun.rotation) * BULLET_SPEED
	bullet.velocity.x *= $Player.scale.x 
	bullet.rotation = bullet.velocity.angle()
	
func creat_dust_effect():
	var dust_pos = global_position
	dust_pos.x += randf_range(-4,4)
	Utils.instance_scene_on_main(DUST_EFFECT, dust_pos)
