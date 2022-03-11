extends Button


# Declare member variables here. Examples:
var paused = false
onready var menu = $"../PauseMenu"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if event.is_action_pressed("pause"):
		pause()

func _pressed():
	pause()
	
func pause():
	paused = !paused
	get_tree().paused = paused
	if menu:
		menu.visible = paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
