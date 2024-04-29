extends Node

var custom_data = {
	MISSILES_UNLOCKED = false,
	BOSS_DEFEATED = false
}

var is_loading = false 

func Save_Game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	save_game.store_line(JSON.stringify(custom_data))
	
	var persistingnodes =  get_tree().get_nodes_in_group("Persists")
	for node in persistingnodes:
		var node_data = node.save()
		save_game.store_line(JSON.stringify(node_data))
	save_game.close()

func Load_Game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var persistingnodes =  get_tree().get_nodes_in_group("Persists")
	for node in persistingnodes:
		node.queue_free()
		
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	if not save_game.eof_reached():
		custom_data = JSON.parse_string(save_game.get_line())
	
	while not save_game.eof_reached():
		var current_line = JSON.parse_string(save_game.get_line())
		if current_line != null:
			var new_node = load(current_line["filename"]).instantiate()
			get_node(current_line["parent"]).add_child(new_node, true)
			new_node.position = Vector2(current_line["position_x"], current_line["position_y"])
			for property in current_line.keys():
				if (property == "filename" 
				or property == "parent" 
				or property == "position_x" 
				or property == "position_y"):
					continue
				new_node.set(property, current_line[property])
	save_game.close
