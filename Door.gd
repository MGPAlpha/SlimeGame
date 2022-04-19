extends Area2D

onready var animatedSprite = $AnimatedSprite

var switch = 0

func _ready():
	pass

func open_door():
	animatedSprite.set_frame(1)

func close_door():
	animatedSprite.set_frame(0)

#extends AnimatedSprite
#
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
##onready var animatedSprite = $AnimatedSprite
#var button1_mass = 0.0
#var button2_mass = 0.0
#var button1 = false
#var button2 = false
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	self.connect("add_mass1", self, "_on_SlimeRoot_add_mass1")
#	self.connect("add_mass2", self, "_on_SlimeRoot_add_mass2")
#	self.connect("subtract_mass1", self, "_on_SlimeRoot_subtract_mass1")
#	self.connect("subtract_mass2", self, "_on_SlimeRoot_subtract_mass2")
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if (button1 && button2):
#		self.set_frame(1)
#	else:
#		self.set_frame(0)
#
#func _on_SlimeRoot_add_mass1(current_mass):
#	button1_mass += current_mass
#	if (button1_mass >= .25):
#		button1 = true
#
#func _on_SlimeRoot_add_mass2(current_mass):
#	button2_mass += current_mass
#	if (button2_mass >= .25):
#		button2 = true
#
#func _on_SlimeRoot_subtract_mass1(current_mass):
#	button1_mass -= current_mass
#	if (button1_mass < .25):
#		button1 = false
#
#func _on_SlimeRoot_subtract_mass2(current_mass):
#	button2_mass -= current_mass
#	if (button2_mass < .25):
#		button2 = false
