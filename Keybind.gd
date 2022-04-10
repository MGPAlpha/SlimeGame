extends Control

var can_change_key = false
var action_string
enum ACTIONS {jump, left, right, split, merge, pause}

func _ready():
	_set_keys()  
  
func _set_keys():
	for j in ACTIONS:
		get_node("Bind_" + str(j)).set_pressed(false)
		if !InputMap.get_action_list(j).empty():
			get_node("Bind_" + str(j)).set_text(InputMap.get_action_list(j)[0].as_text())
		else:
			get_node("Bind_" + str(j)).set_text("No Button!")

func _on_Bind_jump_pressed():
	_mark_button("jump")

func _on_Bind_left_pressed():
	_mark_button("left")

func _on_Bind_right_pressed():
	_mark_button("right")
	
func _on_Bind_split_pressed():
	_mark_button("split")
	
func _on_Bind_merge_pressed():
	_mark_button("merge")
	
func _on_Bind_pause_pressed():
	_mark_button("pause")

func _mark_button(string):
	can_change_key = true
	action_string = string
	
	for j in ACTIONS:
		if j != string:
			get_node("Bind_" + str(j)).set_pressed(false)

func _input(event):
	if event is InputEventKey: 
		if can_change_key:
			_change_key(event)
			can_change_key = false

func _change_key(new_key):
	#Delete key of pressed button
	if !InputMap.get_action_list(action_string).empty():
		InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[0])
	
	#Check if new key was assigned somewhere
	for i in ACTIONS:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
			
	#Add new Key
	InputMap.action_add_event(action_string, new_key)
	
	_set_keys()
