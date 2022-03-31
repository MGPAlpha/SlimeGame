extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var button1_mass = 0
var button2_mass = 0
var button1
var button2


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("add_mass1", self, "_on_SlimeRoot_add_mass1")
	self.connect("add_mass2", self, "_on_SlimeRoot_add_mass2")
	self.connect("subtract_mass1", self, "_on_SlimeRoot_subtract_mass1")
	self.connect("subtract_mass2", self, "_on_SlimeRoot_subtract_mass2")
	button1 = get_children()[0]
	button2 = get_children()[1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SlimeRoot_add_mass1(current_mass):
	button1_mass += current_mass
	if (button1_mass >= .25):
		button1.get_children()[0].set_frame(1)
		button1.get_children()[2].get_children()[1].position += Vector2(0, 25)
		#button1.get_children()[2].get_children()[1]

func _on_SlimeRoot_add_mass2(current_mass):
	button2_mass += current_mass
	if (button2_mass >= .25):
		button2.get_children()[0].set_frame(1)
		button2.get_children()[2].get_children()[1].position += Vector2(0, 25)
		#button2.get_children()[2].get_children()[1]

func _on_SlimeRoot_subtract_mass1(current_mass):
	button1_mass -= current_mass
	if (button1_mass < .25):
		button1.get_children()[0].set_frame(0)
		button1.get_children()[2].get_children()[1].position -= Vector2(0, 25)
		#button1.get_children()[2].get_children()[1]

func _on_SlimeRoot_subtract_mass2(current_mass):
	button2_mass -= current_mass
	if (button2_mass < .25):
		button2.get_children()[0].set_frame(0)
		button2.get_children()[2].get_children()[1].position -= Vector2(0, 25)
		#button2.get_children()[2].get_children()[1]
