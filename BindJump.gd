extends "Keybind.gd"

func _ready():
	self.action = "jump"
	self.scancode = KEY_SPACE
	self.start()
