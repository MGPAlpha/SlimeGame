extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var mergeArea = $MergeArea

var isActiveSlime = false

const UP = Vector2(0, -1)
const GRAVITY = 30
const MAXFALLSPEED = 200
const MAXSPEED = 300
const JUMPFORCE = 500
const ACCELERATION = 2000
const DRAGX = 800
const RATIOADJUSTSPEED = .3

var mass = 1.0

var motion = Vector2()

var splitHoldTime = 0
var useAdvancedSplit = false
var splitRatio = .5

signal request_split
signal request_advanced_split
signal request_merge

func initialize(mass):
	self.mass = mass
	scale *= sqrt(mass)

func _physics_process(delta):
	motion = move_and_slide(motion, UP)
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

	if is_on_floor():
		motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
		motion.x = move_toward(motion.x, 0, delta * DRAGX)
	
	if isActiveSlime:
		
		if Input.is_action_pressed("split"):
			splitHoldTime += delta
			if splitHoldTime > 1:
				useAdvancedSplit = true
			if useAdvancedSplit:
				if Input.is_action_pressed("left"):
					splitRatio = move_toward(splitRatio, .15, delta * RATIOADJUSTSPEED)
				if Input.is_action_pressed("right"):
					splitRatio = move_toward(splitRatio, .5, delta * RATIOADJUSTSPEED)					
		else:
			
			if Input.is_action_just_released("split"):
				
				if useAdvancedSplit:
					var splitDirection = get_viewport().get_mouse_position() - get_global_transform_with_canvas().get_origin()
					splitDirection = splitDirection.normalized()
					emit_signal("request_advanced_split", self, splitDirection, splitRatio)
				else:
					emit_signal("request_split", self)
				splitHoldTime = 0
				splitRatio = 0
				useAdvancedSplit = false
			
			if Input.is_action_just_pressed("merge"):
				var slimesToMerge = mergeArea.get_overlapping_bodies()
				if slimesToMerge.size() > 1:
					emit_signal("request_merge", slimesToMerge)
			
			if Input.is_action_pressed("right"):
				motion.x += ACCELERATION * delta
				$AnimatedSprite.flip_h = true
				animatedSprite.animation = "run"
			elif Input.is_action_pressed("left"):
				motion.x -= ACCELERATION * delta
				$AnimatedSprite.flip_h = false
				animatedSprite.animation = "run"
			else:
				motion.x = lerp(motion.x, 0, .2)
				animatedSprite.animation = "idle"
			
			if is_on_floor():
				if Input.is_action_just_pressed("jump"):
					motion.y = -JUMPFORCE
