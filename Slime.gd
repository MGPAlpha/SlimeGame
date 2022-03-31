extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var mergeArea = $MergeArea

var isActiveSlime = false

const UP = Vector2(0, -1)
const GRAVITY = 30
const MAXFALLSPEED = 200
const MAXSPEED = 300
const JUMPFORCE = 550
const ACCELERATION = 2000
const DRAGX = 800
const RATIOADJUSTSPEED = .3

var mass = 1.0

var motion = Vector2()
var prevY = 16
var turning = false

var splitHoldTime = 0
var useAdvancedSplit = false
var splitRatio = .5

signal request_split
signal request_advanced_split
signal request_merge
signal request_switch

var paused = false

func initialize(mass, flipH = false):
	self.mass = mass
	scale *= sqrt(mass)
	$AnimatedSprite.flip_h = flipH

func _physics_process(delta):
	prevY = position.y
	motion = move_and_slide(motion, UP)
#	if (turning && (position.y - prevY) > 0):
#		print(position.y)
#		print(prevY)
#		turning = false
	motion.y += (GRAVITY + (abs(log(mass))))
	if motion.y > min(MAXFALLSPEED + (50 * (1 + abs(log(mass)))), 1000):
		motion.y = min(MAXFALLSPEED + (50 * (1 + abs(log(mass)))), 1000)

	#if is_on_floor():
#		motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
#		motion.x = move_toward(motion.x, 0, delta * DRAGX)
	motion.x = clamp(motion.x, -(MAXSPEED + (1 - mass) / mass), (MAXSPEED + (1 - mass) / mass))
	motion.x = move_toward(motion.x, 0, delta * DRAGX)
	
	if isActiveSlime && !paused:
		
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
				animatedSprite.play("active_run")
			elif Input.is_action_pressed("left"):
				motion.x -= ACCELERATION * delta
				$AnimatedSprite.flip_h = false
				animatedSprite.play("active_run")
			else:
				motion.x = lerp(motion.x, 0, .2)
				animatedSprite.play("active_idle")
			
			if is_on_floor():
				if Input.is_action_just_pressed("jump"):
#					if mass == 1:
#						motion.y = -JUMPFORCE 
#					else:
#						motion.y = -JUMPFORCE * (1 + ease(max(1 - mass, 0), 1))
					turning = true
					motion.y = -JUMPFORCE * ((1 + ease(max(1 - mass, 0) / 2, 1)))
	elif !isActiveSlime && !paused:
		animatedSprite.play("inactive_idle")
