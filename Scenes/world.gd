extends Node

var MainInstances = Resourceloader.instances

@onready var currentLevel = $Level_00

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	Music._list_play()
	
	if SaverAndLoader.is_loading == true:
		SaverAndLoader.Load_Game()
		SaverAndLoader.is_loading = false
		
	MainInstances.Player.hit_door.connect(_player_hit_door)


func change_levels(door):
	var offset = currentLevel.position
	currentLevel.queue_free()
	var NewLevel = load(door.new_level_path)
	var newLevel = NewLevel.instantiate()
	add_child(newLevel)
	var newDoor = get_door_with_connection(door, door.connection)
	var exit_position = newDoor.position - offset
	newLevel.position = door.position - exit_position

func get_door_with_connection(notDoor, connection):
	var doors = get_tree().get_nodes_in_group("door")
	for door in doors:
		if door.connection == connection and door != notDoor:
			return door
	return null

func _player_hit_door(door):
	call_deferred("change_levels", door)
	
func _on_player_death():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Menus/game_over.tscn")
