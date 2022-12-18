extends KinematicBody2D

onready var dashParticles = $DashParticles
onready var playerPosition = $PlayerPosition
onready var knifeReloadTimer = $KnifeReload
onready var sprite = $Sprite
onready var animationTree = $AnimationTree
const knifeScene = preload("res://PlayerRelated/knife/Knife.tscn")

var baseDamage = 100

export (int) var walkSpeed = 400
export (int) var dashSpeed = 2000
export (int) var healthPoints = 3
export (float) var attackSpeed = 1.0
export (float) var damage = baseDamage

var velocity = Vector2()
var direction = Vector2()

var canDash = true
var isDashing = false

func init_dash(): 
	canDash = false
	isDashing =true
	dashParticles.set_emitting(true)
	yield(get_tree().create_timer(0.1),"timeout")
	dashParticles.set_emitting(false)
	canDash = true
	isDashing = false

func dash(dashDirection):
	if dashDirection.x == 0 && dashDirection.y == 0:
		dashDirection = Vector2(1,0)
	velocity = dashDirection.normalized() * dashSpeed
	

func player_movement():
	
	var movingX = false
	var movingY = false
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
		movingX = true

	if Input.is_action_pressed("ui_left"):
		direction.x = -1
		movingX = true

	if Input.is_action_pressed("ui_down"):
		direction.y = 1
		movingY = true

	if Input.is_action_pressed("ui_up"):
		direction.y = -1
		movingY = true

	var newDirection = Vector2()

	if movingX || movingY :
		if(movingX):
			newDirection.x = direction.x
		if(movingY):
			newDirection.y = direction.y
			
		if isDashing:
			dash(newDirection)
		else:
			velocity = newDirection.normalized() * walkSpeed
			animationTree.get('parameters/playback').travel('run')
	else:
		animationTree.get('parameters/playback').travel('idle')
		
	if Input.is_action_just_pressed("dash"):
		init_dash()
		
	sprite.flip_h = direction.x == -1
		
	velocity.x = lerp(velocity.x,0,0.3)
	velocity.y = lerp(velocity.y,0,0.3)

func player_shooting():
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and knifeReloadTimer.is_stopped():
		var knife = knifeScene.instance()
		knife.position = playerPosition.global_position
		knife.look_at(get_global_mouse_position())
		get_tree().root.add_child(knife)
		knifeReloadTimer.start()


func _physics_process(_delta):
	player_movement()
	player_shooting()
	velocity = move_and_slide(velocity)
