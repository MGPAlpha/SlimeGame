extends "Keybind.gd"

func _ready():
	self.action = "pause"
	self.scancode = KEY_ESCAPE
	self.start()
