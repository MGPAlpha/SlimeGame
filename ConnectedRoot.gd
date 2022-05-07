extends Node2D

export (NodePath) var path

onready var trigger = get_node(path)

onready var buttons = trigger.get_children()
var trigger_total = 0
var num_buttons
var prev_value = 0

func _ready():
	num_buttons = buttons.size()
	for button in buttons:
		button.connect("button_up", self, "released")
		button.connect("button_down", self, "pressed")

func _process(_delta):
	if prev_value != (trigger_total / num_buttons):
		if (trigger_total / num_buttons) == 1:
			for item in get_children():
				item.activate()
		else:
			for item in get_children():
				item.deactivate()
		prev_value = (trigger_total / num_buttons)

func released(button):
	self.trigger_total -= 1.0

func pressed(button):
	self.trigger_total += 1.0


# Attempt 1
#onready var triggers = get_node(path)
#
#var prev_check
## Declare member variables here. Examples:
## var a = 2
## var b = "text"
#
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	prev_check = triggers.check()
#
#func _process(_delta):
#	triggers = get_node(path)
#	if prev_check != triggers.check():
#		if triggers.check() == 1:
#			for door in get_children():
#				door.open_door()
#		else:
#			for door in get_children():
#				door.close_door()
#		prev_check = triggers.check()
## Called every frame. 'delta' is the elapsed time since the previous frame.
##func _process(delta):
##	pass
