extends KinematicBody2D

onready var dashParticles = $DashParticles
onready var playerPosition = $PlayerPosition
onready var knifeReloadTimer = $KnifeReload
const knifeScene = preload("res://PlayerRelated/knife/Knife.tscn")

export (int) var walkSpeed = 400
export (int) var dashSpeed = 2000

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

func dash():
	var dashDirection = direction
	if dashDirection.x == 0 && dashDirection.y == 0:
		dashDirection = Vector2(1,0)
	velocity = dashDirection.normalized() * dashSpeed
	

func player_movement():
	if isDashing:
		dash()
	else:
		direction = Vector2()
		if Input.is_action_pressed("ui_right"):
			direction.x += 1

		if Input.is_action_pressed("ui_left"):
			direction.x -= 1

		if Input.is_action_pressed("ui_down"):
			direction.y += 1

		if Input.is_action_pressed("ui_up"):
			direction.y -= 1

		velocity = direction.normalized() * walkSpeed
		
		if Input.is_action_just_pressed("dash"):
			init_dash()
		
	velocity.x = lerp(velocity.x,0,0.1)
	velocity.y = lerp(velocity.y,0,0.1)

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
