extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite
onready var mergeArea = $MergeArea

var isActiveSlime = false

const UP = Vector2(0, -1)
const GRAVITY = 30
const MAXFALLSPEED = 200
const MAXSPEED = 300
const JUMPFORCE = 500
const ACCELERATION = 10

var mass = 100

var motion = Vector2()

signal request_split
signal request_merge

func initialize(mass):
	self.mass = mass
	scale *= sqrt(mass / 100.0)

func _physics_process(delta):
	motion = move_and_slide(motion, UP)
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

	
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	
	
	
	if isActiveSlime:
		
		if Input.is_action_just_pressed("split"):
			emit_signal("request_split", self)
			
		
		if Input.is_action_just_pressed("merge"):
			var slimesToMerge = mergeArea.get_overlapping_bodies()
			if slimesToMerge.size() > 1:
				emit_signal("request_merge", slimesToMerge)
				
		
		if Input.is_action_pressed("right"):
			motion.x += ACCELERATION
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.animation = "active_run"
		elif Input.is_action_pressed("left"):
			motion.x -= ACCELERATION
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.animation = "active_run"
		else:
			motion.x = lerp(motion.x, 0, .2)
			animatedSprite.animation = "active_idle"
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Walk"), log(abs(motion.x*motion.x)))
		if !$AudioWalk.playing:
			$AudioWalk.play()
		
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				motion.y = -JUMPFORCE
				$AudioJump.play()
	else:
		motion.x = lerp(motion.x, 0, .2)
		$AnimatedSprite.animation = "inactive_idle"
			
	#if motion.y < 0:
		#animatedSprite.animation = "jump"
	#elif motion.y > 0 and !is_on_floor():
		#animatedSprite.animation = "fall"
	

	
	

