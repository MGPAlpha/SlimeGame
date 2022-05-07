extends Area2D

onready var animatedSprite = $AnimatedSprite

export (float) var target_mass = 0.25

var prev_mass = 0
var curr_mass = 0
var num_slimes = 0

var prev_slimes = []
var curr_slimes = []

signal button_down
signal button_up
signal other_change

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func initialize(mass = target_mass):
	self.target_mass = mass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	curr_slimes = overlapping_bodies()
	self.num_slimes = curr_slimes.size()
	self.curr_mass = get_masses()
	if curr_slimes != prev_slimes:
		if ((self.curr_mass > self.prev_mass) && (self.curr_mass > self.target_mass)):
			if animatedSprite.get_frame() == 0:
				animatedSprite.set_frame(1)
				emit_signal("button_down", self)
		elif ((self.curr_mass < self.prev_mass) && (self.curr_mass < self.target_mass)):
			if animatedSprite.get_frame() == 1:
				animatedSprite.set_frame(0)
				emit_signal("button_up", self)
		else:
			emit_signal("other_change", self)
		prev_slimes = curr_slimes
		self.prev_mass = self.curr_mass

func overlapping_bodies():
	var slimes = []
	for item in get_overlapping_bodies():
		if (item in get_children()) == false:
			slimes.append(item)
	return slimes

func get_masses():
	var mass = 0
	for item in overlapping_bodies():
		mass += item.mass
	return mass

func set_color(color):
	animatedSprite.set_animation(color)
	print(color)
