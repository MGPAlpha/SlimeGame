extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const ZOOM_FACTOR = .8
const ZOOM_RATE = 1/16.0

var curr_zoom = ZOOM_FACTOR


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var zoom_target = sqrt(get_parent().mass) * ZOOM_FACTOR
	curr_zoom += (zoom_target - curr_zoom) * ZOOM_RATE
	zoom.x = curr_zoom
	zoom.y = curr_zoom
