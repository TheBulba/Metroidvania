extends "res://Enemies/enemy.gd"

@export var acceleration : int = 100

var maininstances = Resourceloader.instances

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	
	var player = maininstances.Player
	
	if player != null:
		chase_player(player, delta)
	if $Top.is_colliding():
		velocity.y = MAX_SPEED
	
	
	move_and_slide()

func chase_player(player, delta):
	var direction = (player.global_position - global_position).normalized()
	velocity += direction * acceleration * delta
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	velocity.y = clamp(velocity.y, -MAX_SPEED, MAX_SPEED)
	$Sprite2D.flip_h = global_position < player.global_position


func _on_visible_on_screen_notifier_2d_screen_entered():
	set_physics_process(true)
