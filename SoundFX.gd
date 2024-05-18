extends Node

var sounds_path = "res://Assets/Audio/SFX/"

var sounds = {
	"Bullet" : load(sounds_path + "Bullet.wav"),
	"Click" : load(sounds_path + "Click.wav"),
	"EnemyDie" : load(sounds_path + "EnemyDie.wav"),
	"Explosion" : load(sounds_path + "Explosion.wav"),
	"Hurt" : load(sounds_path + "Hurt.wav"),
	"Jump" : load(sounds_path + "Jump.wav"),
	"Pause" : load(sounds_path + "Pause.wav"),
	"PowerUp" : load(sounds_path + "PowerUp.wav"),
	"Step" : load(sounds_path + "Step.wav"),
	"Unpause" : load(sounds_path + "Unpause.wav"),
}

@onready var Sound_Players = get_children()

func play(sound_string,pitch = 0, volume = 0):
	for soundplayer in Sound_Players:
		if not soundplayer.is_playing():
			soundplayer.pitch_scale = pitch
			soundplayer.volume_db = volume
			soundplayer.stream = sounds[sound_string]
			soundplayer.play()
			return
	print("too many sounds")
