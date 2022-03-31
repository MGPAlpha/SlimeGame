extends Node2D

export (PackedScene) var basicSlime

onready var camera = $Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = 0
var slimeArray = []

signal add_mass1(current_mass)
signal add_mass2(current_mass)
signal subtract_mass1(current_mass)
signal subtract_mass2(current_mass)

# Called when the node enters the scene tree for the first time.
func _ready():
	var originalSlime = new_slime()
	originalSlime.isActiveSlime = true
	switch_camera(originalSlime)
	add_child(originalSlime)
	slimeArray.append(originalSlime)

# Creates new slime with signals connected, does not add to scene
func new_slime():
	var newSlime = basicSlime.instance()
	newSlime.connect("request_split", self, "perform_split")
	newSlime.connect("request_advanced_split", self, "perform_advanced_split")
	newSlime.connect("request_merge", self, "perform_merge")
	newSlime.connect("request_switch", self, "perform_switch")
	return newSlime

func _process(delta):
	if Input.is_action_just_pressed("switch"):
#		for slime in get_children():
#			print(slime.name + ": " + String(slime.isActiveSlime))
#		print("-------")
		if get_children().size() > 1:
			perform_switch(get_children())
#			for slime in get_children():
#				print(slime.name + ": " + String(slime.isActiveSlime))
#			print("-------")

func switch_camera(slime):
	camera.get_parent().remove_child(camera)
	slime.add_child(camera)
	#print(slime)

func perform_split(slime):
	var oldMass = slime.mass
	var splitDir = slime.animatedSprite.flip_h
	var activeSlime = new_slime()
	var inactiveSlime = new_slime()
	activeSlime.position = slime.position
	inactiveSlime.position = slime.position
	activeSlime.initialize(oldMass / 2, splitDir)
	inactiveSlime.initialize(oldMass / 2, splitDir)
	activeSlime.motion = slime.motion
	inactiveSlime.motion = slime.motion
	activeSlime.isActiveSlime = true
	add_child(activeSlime)
	slimeArray.append(activeSlime)
	add_child(inactiveSlime)
	slimeArray.append(inactiveSlime)
	switch_camera(activeSlime)
	slime.queue_free()
	slimeArray.remove(active)
	active = slimeArray.find(activeSlime)

func perform_advanced_split(slime, direction, massRatio):
	var oldMass = slime.mass
	var activeMass = oldMass * massRatio
	var inactiveMass = oldMass * (1-massRatio)
	var activeSlime = new_slime()
	var inactiveSlime = new_slime()
	activeSlime.position = slime.position
	inactiveSlime.position = slime.position
	activeSlime.initialize(activeMass)
	inactiveSlime.initialize(inactiveMass)
	activeSlime.motion = direction / activeMass * 200
	inactiveSlime.motion = -direction / inactiveMass * 200
	activeSlime.isActiveSlime = true
	add_child(activeSlime)
	add_child(inactiveSlime)
	switch_camera(activeSlime)
	slime.queue_free()

func perform_merge(slimes):
	var mergedSlime = new_slime()
	var mergedPos = Vector2.ZERO
	var totalMass = 0
	for slime in slimes:
		totalMass += slime.mass
		mergedPos += slime.position * slime.mass
		slime.queue_free()
		slimeArray.remove(slimeArray.find(slime))
	mergedPos /= totalMass
	switch_camera(mergedSlime)
	mergedSlime.position = mergedPos
	mergedSlime.isActiveSlime = true
	mergedSlime.initialize(totalMass)
	add_child(mergedSlime)
	slimeArray.append(mergedSlime)
	active = slimeArray.find(mergedSlime)

func perform_switch(slimes):
	var switched = false
	var index = 0
	while !switched:
		if (slimes[index % (slimes.size())].isActiveSlime):
			slimes[index % (slimes.size())].isActiveSlime = false
			index += 1
			slimes[index % (slimes.size())].isActiveSlime = true
			switch_camera(slimes[index % (slimes.size())])
			switched = true
		else:
			index += 1

func _on_Area2D_Button1_body_entered(body):
	if ("Slime" in body.name):
		emit_signal("add_mass1", body.mass)

func _on_Area2D_Button2_body_entered(body):
	if ("Slime" in body.name):
		emit_signal("add_mass2", body.mass)

func _on_Area2D_Button1_body_exited(body):
	if ("Slime" in body.name):
		emit_signal("subtract_mass1", body.mass)

func _on_Area2D_Button2_body_exited(body):
	if ("Slime" in body.name):
		emit_signal("subtract_mass2", body.mass)
