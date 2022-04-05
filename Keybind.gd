# Generic

extends Button

var action
var scancode

var key = InputEventKey.new()
var highlighted = false

func start():
	key.scancode = scancode
	self.text = key.as_text()
	self.set_toggle_mode(true)

func _input(event):
	if self.pressed:
		if event is InputEventKey:
			InputMap.action_erase_event(action, key)
			key = event
			self.text = key.as_text()
			InputMap.action_add_event(action, key)
			self.pressed = false
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		self.pressed = false
