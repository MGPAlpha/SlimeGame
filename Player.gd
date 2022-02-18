extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite

const UP = Vector2(0, -1)
const GRAVITY = 30
const MAXFALLSPEED = 200
const MAXSPEED = 300
const JUMPFORCE = 500
const ACCELERATION = 10

var motion = Vector2()




func _physics_process(delta):
	motion = move_and_slide(motion, UP)
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED

	
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	
	
	
	
	if Input.is_action_pressed("right"):
		motion.x += ACCELERATION
		$AnimatedSprite.flip_h = false
		animatedSprite.animation = "run"
	elif Input.is_action_pressed("left"):
		motion.x -= ACCELERATION
		$AnimatedSprite.flip_h = true
		animatedSprite.animation = "run"
	else:
		motion.x = lerp(motion.x, 0, .2)
		animatedSprite.animation = "idle"
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			motion.y = -JUMPFORCE
			
	if motion.y < 0:
		animatedSprite.animation = "jump"
	elif motion.y > 0 and !is_on_floor():
		animatedSprite.animation = "fall"
	

	
	

