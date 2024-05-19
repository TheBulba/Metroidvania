extends Node

@export var music_list: Array[AudioStream] = []

var music_list_index = 0

@onready var musicplayer = $AudioStreamPlayer2D

func _list_play():
	assert (music_list.size() > 0)
	musicplayer.stream = music_list[music_list_index]
	musicplayer.play()
	music_list_index += 1
	if music_list_index == music_list.size():
		music_list_index = 0

func _list_stop():
	musicplayer.stop()

func _on_audio_stream_player_2d_finished():
	_list_play()
