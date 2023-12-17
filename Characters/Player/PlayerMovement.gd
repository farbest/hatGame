extends CharacterBody2D

@onready var dashParticles = $DashParticles
@onready var playerPosition = $PlayerPosition
@onready var knifeReloadTimer = $KnifeReload
@onready var sprite = $Sprite2D
@onready var animationTree = $AnimationTree
const knifeScene = preload("res://Projectiles/Knife.tscn")

#animation state
const RUN = "run"
const IDLE = "idle"

var baseDamage = 100

@export  var walkSpeed = 400
@export  var dashSpeed = 2000
@export  var healthPoints = 3
@export  var attackSpeed = 1.0
@export  var damage = baseDamage

var canDash = true
var isDashing = false

func init_dash(): 
	canDash = false
	isDashing =true
	dashParticles.set_emitting(true)
	await get_tree().create_timer(0.1).timeout
	dashParticles.set_emitting(false)
	canDash = true
	isDashing = false

func dash(dashDirection):
	if dashDirection.x == 0 && dashDirection.y == 0:
		dashDirection = Vector2(1,0)
	var vel = dashDirection.normalized() * dashSpeed
	return vel
	
func get_movement_direction():
	var direction = Vector2()
	
	direction.x = 0
	direction.y = 0
	
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
		
	return direction

func get_player_movement():
	
	var direction = get_movement_direction()
	var vel = Vector2()

	if direction.x != 0 || direction.y != 0 :
		if isDashing:
			vel = dash(direction)
		else:
			vel = direction.normalized() * walkSpeed
			animationTree.get('parameters/playback').travel('run')
	else:
		animationTree.get('parameters/playback').travel('idle')
		
	if Input.is_action_just_pressed("dash"):
		init_dash()
		
	vel.x = lerp(vel.x,0.0,0.3)
	vel.y = lerp(vel.y,0.0,0.3)
	
	return vel
	

func shoot_projectile():
		var knife = knifeScene.instantiate()
		get_tree().root.add_child(knife)
		
		knife.position = playerPosition.global_position
		knife.look_at(get_global_mouse_position())

		knifeReloadTimer.start()

func set_sprite_direction(vel:Vector2):
	sprite.flip_h = vel.x < 0

func _physics_process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and knifeReloadTimer.is_stopped():
		shoot_projectile()
		
	var vel = get_player_movement()
	set_sprite_direction(vel)
	set_velocity(vel)
	move_and_slide()
	
func pickup_item(str):
	print("picking " + str)
	var sprite = Sprite2D.new()
	sprite.texture = load("res://Items/hats.png")
	sprite.hframes = 8
	sprite.vframes = 15
	sprite.frame = 16
	sprite.move_local_y(-6)
	self.add_child(sprite)
	
	

