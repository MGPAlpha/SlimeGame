extends Node2D

export (PackedScene) var basicButton
export (String, "blue", "green", "red", "yellow") var color
var button_array = []
var trigger_array = []
var trigger_total
var prev_array = []
var num_buttons

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Version 2
# Called when the node enters the scene tree for the first time.
func _ready():
	self.num_buttons = get_children().size()
	self.trigger_total = 0.0
	for button in get_children():
		button.connect("button_up", self, "released")
		button.connect("button_down", self, "pressed")
		button.set_color(color)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#		pass
func released(button):
#	if self.trigger_total / self.num_buttons == 1:
#		emit_signal("deactivate", self)
#		print("off")
	self.trigger_total -= 1.0
	#print("Released: " + str(trigger_total / num_buttons))
	button.get_children()[2].position -= Vector2(0, 25)

func pressed(button):
	self.trigger_total += 1.0
	#print("Pressed: " + str(trigger_total / num_buttons))
	button.get_children()[2].position += Vector2(0, 25)
#	if self.trigger_total / self.num_buttons == 1:
#		emit_signal("activate", self)
#		print("on")

func check():
	return float(trigger_total / num_buttons)

# Version 1 - generate new buttons through code
## Called when the node enters the scene tree for the first time.
#func _ready():
#	var original_button = new_button()
#	add_child(original_button)
#
#func new_button():
#	var newButton = basicButton.instance(0.25)
#	newButton.connect("button_up", self, "released")
#	newButton.connect("button_down", self, "pressed")
#	return newButton
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if Input.is_action_just_pressed("jump"):
#		add_child(new_button())
#func released():
#	pass
#
#func pressed():
#	pass
