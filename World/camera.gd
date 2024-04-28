extends Camera2D

var shake = 0


func _ready():
	Events.addscreenshake.connect(screenshake)
	Resourceloader.instances.Camera = self
	
func _exit_tree():
	Resourceloader.instances.Camera = null
	
func _process(delta):
	offset = Vector2(randf_range(-shake,shake), randf_range(-shake,shake))

func screenshake(amount, duration):
	shake = amount
	$Timer.start(duration)

func _on_timer_timeout():
	shake = 0
