extends CharacterBody2D

#note if anything breaks remove floor_snap

const DUST_EFFECT = preload("res://Effect/dust_effect.tscn")
const PLAYER_BULLET = preload("res://Player/player_bullet.tscn")
const PLAYER_MISSILE = preload("res://Player/player_missile.tscn")
const JumpEffect = preload("res://Effect/jump_effect.tscn")
const WALLSLIDE_EFFECT = preload("res://Effect/wall_slide_effect.tscn")

var Playerstats = Resourceloader.playerstats
var Instances = Resourceloader.instances

const SPEED = 256
const MAX_SPEED = 64 
const FRICTION = 0.25
const GRAVITY = 200
const JUMP_FORCE = 128.0
const MAX_JUMP = 168.0
const BULLET_SPEED = 200
const MISSILE_SPEED = 150

var invincible = false
var jumpwindow = true
var jumping = false
var in_air = false
var double_jump = true
var wall_slide_speed = 48
var state = MOVE

signal hit_door(door)

enum {
	MOVE,
	WALL_SLIDE
}

func set_invincible(value):
	invincible = value

func _ready():
	Playerstats.playerdied.connect(_ondied)
	Instances.Player = self
	call_deferred("assign_camera")

func _exit_tree():
	Instances.Player = null

func _physics_process(delta):
	
	var wall_axis = get_wall_axis()
	
	match state:
		MOVE:
			var x = get_input()
			horizontal_velocity(x, delta)
			gravity(delta)
			jump()
			coyote_jump()
			landed()
			get_animation(x)
			floor_snap_length = 2
			move_and_slide()
			wallslide_check(x, wall_axis)
		WALL_SLIDE:
			$Sprite_Animator.play("wall_slide")
			if wall_axis != 0:
				$Player.scale.x = wall_axis
			
			wall_slide_jump_check(wall_axis)
			wall_slide_drop_check(delta, wall_axis)
			wall_slide_fast_slide(delta)
			move_and_slide()
			wall_detach_check(wall_axis)
	
	#shooting
	if Input.is_action_pressed("shoot") and $BulletTimer.time_left == 0: 
		shoot()
		$BulletTimer.start()
		
	if Input.is_action_pressed("Fire_Missile") and $BulletTimer.time_left == 0: 
		if Playerstats.missiles > 0 and Playerstats.missiles_unlocked:
			fire_missile()
			$BulletTimer.start()
	
	#Absolute mess which i don't understand why it works
	if is_on_floor():
		jumping = false
		jumpwindow = true
	elif jumping == false and jumpwindow == true and !is_on_floor() :
		jumpwindow = false
		$Coyote.start()

	
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

func wallslide_check(x, wall_axis):
	if is_on_wall_only() and x == -wall_axis:
		state = WALL_SLIDE
		double_jump = true
		
func get_wall_axis():
	var is_right_wall = test_move(transform, Vector2.RIGHT)
	var is_left_wall = test_move(transform, Vector2.LEFT)
	return int(is_left_wall) - int(is_right_wall) 

func wall_slide_jump_check(wall_axis):
		if Input.is_action_just_pressed("ui_up"):
			velocity.x = wall_axis * MAX_SPEED
			velocity.y = -JUMP_FORCE
			state = MOVE
			var dust_pos = global_position + Vector2(wall_axis * 4 ,-2)
			var dust = Utils.instance_scene_on_main(WALLSLIDE_EFFECT,dust_pos)
			dust.scale.x = wall_axis
			
func wall_slide_drop_check(delta, wall_axis):
	var x = Input.get_axis("ui_left", "ui_right")
	
	if x == -wall_axis:
		pass
	else:
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			velocity.x = x * SPEED * delta
			state = MOVE
		else:
			state = MOVE
	
func wall_slide_fast_slide(delta):	
	var max_slide_speed = wall_slide_speed
	if Input.is_action_pressed("ui_down"):
		max_slide_speed = JUMP_FORCE
	velocity.y += GRAVITY * delta
	velocity.y = min(velocity.y, max_slide_speed)
		
func wall_detach_check(wall_axis):
	if wall_axis == 0 or is_on_floor():
		state = MOVE

func jump():
		if is_on_floor() and Input.is_action_just_pressed("ui_up"): 
			double_jump = true
			velocity.y = -JUMP_FORCE
			jumping = true
			Utils.instance_scene_on_main(JumpEffect, global_position)
		elif Input.is_action_just_released("ui_up") and velocity.y < -JUMP_FORCE/2:
			velocity.y = -JUMP_FORCE/2
		elif Input.is_action_just_pressed("ui_up") and double_jump == true:
			jumping = true
			double_jump = false
			velocity.y = -JUMP_FORCE * 0.75
			Utils.instance_scene_on_main(JumpEffect, global_position)
		
		#Added to limit platform boosted
		velocity.y = clamp(velocity.y, -GRAVITY, MAX_JUMP)

func landed():
	
	if is_on_floor() and in_air == true: 
		Utils.instance_scene_on_main(JumpEffect, global_position)
		in_air = false
	elif !is_on_floor():
		in_air = true
		
func coyote_jump():		
	if !is_on_floor() and $Coyote.time_left > 0 and jumping == false:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -JUMP_FORCE
			jumping = true
			
func get_animation(x):
	var facing = sign(get_local_mouse_position().x)
	
	if facing != 0:
		$Player.scale.x = facing
	
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
	
func fire_missile():
	var missile = Utils.instance_scene_on_main(PLAYER_MISSILE, $Player/PlayerGun/PlayerGun/Muzzle.global_position)
	missile.velocity = Vector2.RIGHT.rotated($Player/PlayerGun.rotation) * MISSILE_SPEED
	missile.velocity.x *= $Player.scale.x 
	velocity -= missile.velocity * 0.25
	missile.rotation = missile.velocity.angle()
	Playerstats.set_missiles(-1)
	
func creat_dust_effect():
	var dust_pos = global_position
	dust_pos.x += randf_range(-4,4)
	Utils.instance_scene_on_main(DUST_EFFECT, dust_pos)

func _on_hurtbox_hit(damage):
	if invincible == false:
		Playerstats.set_health(damage)
		$Blink_Animator.play("blink")

func _ondied():
	queue_free()

func _on_power_up_detector_area_entered(area):
	if area is PowerUp:
		area._pickup()

func save():
	var save_dictionary = {
		"filename" : get_scene_file_path(),
		"parent": get_parent().get_path(),
		"position_x" : position.x,
		"position_y" : position.y
	}
	return save_dictionary

func assign_camera():
	$Camera_Follow.remote_path = Resourceloader.instances.Camera.get_path()
