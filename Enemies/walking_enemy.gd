extends "res://Enemies/enemy.gd"

enum DIRECTION{
	LEFT = -1,
	RIGHT = 1
}

@export var WALKING_DIRECTION: DIRECTION

var state

func _ready():
	state = WALKING_DIRECTION

func _physics_process(delta):
	match state:
		DIRECTION.RIGHT:
			velocity.x = MAX_SPEED
			if  $WallRight.is_colliding() or !$FloorRight.is_colliding():
				state = DIRECTION.LEFT
			
		DIRECTION.LEFT:
			velocity.x = -MAX_SPEED
			if  $WallLeft.is_colliding() or !$FloorLeft.is_colliding() :
				state = DIRECTION.RIGHT
			
	$Sprite2D.scale.x = sign(velocity.x)
	floor_snap_length = 2

	move_and_slide()
