extends Node2D

export (PackedScene) var basicSlime

onready var camera = $Camera2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var originalSlime = new_slime()
	originalSlime.isActiveSlime = true
	switch_camera(originalSlime)
	add_child(originalSlime)

# Creates new slime with signals connected, does not add to scene
func new_slime():
	var newSlime = basicSlime.instance()
	newSlime.connect("request_split", self, "perform_split")
	newSlime.connect("request_advanced_split", self, "perform_advanced_split")
	newSlime.connect("request_merge", self, "perform_merge")
	return newSlime

func switch_camera(slime):
	camera.get_parent().remove_child(camera)
	slime.add_child(camera)

func perform_split(slime):
	var oldMass = slime.mass
	var splitDir = 1 if slime.animatedSprite.flip_h else -1
	var activeSlime = new_slime()
	var inactiveSlime = new_slime()
	activeSlime.position = slime.position
	inactiveSlime.position = slime.position
	activeSlime.initialize(oldMass / 2)
	inactiveSlime.initialize(oldMass / 2)
	activeSlime.motion = slime.motion
	inactiveSlime.motion = slime.motion
	activeSlime.isActiveSlime = true
	add_child(activeSlime)
	add_child(inactiveSlime)
	switch_camera(activeSlime)
	slime.queue_free()

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
	activeSlime.motion = slime.motion
	inactiveSlime.motion = slime.motion
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
	mergedPos /= totalMass
	switch_camera(mergedSlime)
	mergedSlime.position = mergedPos
	mergedSlime.isActiveSlime = true
	mergedSlime.initialize(totalMass)
	add_child(mergedSlime)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
