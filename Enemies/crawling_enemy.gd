extends "res://Enemies/enemy.gd"

enum DIRECTION{
	LEFT = -1,
	RIGHT = 1
}

@export var WALKING_DIRECTION: DIRECTION

func _ready():
	$Wall.target_position.x *= WALKING_DIRECTION

func _physics_process(delta):
	if $Wall.is_colliding():
		global_position = $Wall.get_collision_point()
		var normal = $Wall.get_collision_normal()
		rotation = normal.rotated(deg_to_rad(90)).angle()
	else:
		$Floor.rotation_degrees =  -MAX_SPEED * 10 * WALKING_DIRECTION * delta
		if $Floor.is_colliding():
			global_position = $Floor.get_collision_point()
			var normal = $Floor.get_collision_normal()
			rotation = normal.rotated(deg_to_rad(90)).angle()
		else:
			rotation_degrees += 20 * WALKING_DIRECTION
