extends CharacterBody2D

#note if anything breaks remove floor_snap

const SPEED = 256
const MAX_SPEED = 64 
const FRICTION = 0.25
const GRAVITY = 200
const JUMP_FORCE = 128.0

func _physics_process(delta):
	
	var x = get_input()
	horizontal_velocity(x, delta)
	gravity(delta)
	jump()
	get_animation(x)
	
	floor_snap_length = 2
	move_and_slide()




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
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -JUMP_FORCE
	elif Input.is_action_just_released("ui_up") and velocity.y < -JUMP_FORCE/2:
		velocity.y = -JUMP_FORCE/2

func get_animation(x):
	if x > 0:
		$Player.flip_h = false
		$Sprite_Animator.play("Run")
	elif x < 0:
		$Player.flip_h = true
		$Sprite_Animator.play("Run")
	else:
		$Sprite_Animator.play("Idle")	
	
	if !is_on_floor():
		$Sprite_Animator.play("Jump")
