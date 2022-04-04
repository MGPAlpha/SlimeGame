extends "Keybind.gd"

func _ready():
	self.action = "split"
	self.scancode = KEY_Q
	self.start()
