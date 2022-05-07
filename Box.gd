extends RigidBody2D
export (float) var scaling = 0.25


var detectors
var change_mode = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.scale *= scaling
		if child.is_class("Node2D"):
			detectors = child.get_children()
	set_gravity_scale(5)
	set_angular_damp(15)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	detectors[0].rotation = -1 * self.rotation
	if slime_on_top() && get_mode() != RigidBody2D.MODE_KINEMATIC:
		set_mode(RigidBody2D.MODE_KINEMATIC)
	elif get_mode() != RigidBody2D.MODE_RIGID:
		set_mode(RigidBody2D.MODE_RIGID)

func is_on_floor():
	var check = false
	for body in detectors[0].get_overlapping_bodies():
		if ((("Slime" in body.name) == false) && (("Box" in body.name) == false)):
			check = true
	return check

func slime_on_top():
	var check = false
	for body in detectors[0].get_overlapping_bodies():
		if "Slime" in body.name:
			check = true
	return check
