extends Abstract_character

var pickup_factory = load("res://Items/Pickup_factory.gd")

@onready var dashParticles = $DashParticles
@onready var knifeThrowingPosition = $KnifeThrowPosition
@onready var knifeReloadTimer = $KnifeReload
@onready var sprite = $Sprite2D
@onready var animationTree = $AnimationTree
const knifeScene = preload("res://Projectiles/Player/Knife.tscn")

@onready var hat_manager:HatManager = $HatPosition

#animation state
const RUN = "run"
const IDLE = "idle"

var baseDamage = 100

@export  var baseRunSpeed = 400

var runSpeed = baseRunSpeed
@export  var dashSpeed = 2000
@export  var healthPoints = 3
@export  var attackSpeed = 1.0
@export  var damage = baseDamage

var isDashing = false
var lastDirection = Vector2()

func init_dash(): 
	isDashing =true
	await get_tree().create_timer(0.1).timeout
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
	
	if isDashing:
		return dash(lastDirection)
	
	var direction = get_movement_direction()
	var vel = Vector2()
	
	if direction.x != 0 || direction.y != 0 :
		lastDirection = direction
		vel = direction.normalized() * runSpeed
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
		
		knife.position = knifeThrowingPosition.global_position
		knife.look_at(get_global_mouse_position())

		knifeReloadTimer.start()

func set_sprite_direction(lookingDirection:Vector2):
	sprite.flip_h = lookingDirection.x < 0

func _physics_process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and knifeReloadTimer.is_stopped():
		shoot_projectile()
		
	var vel = get_player_movement()
	set_sprite_direction(lastDirection)
	hat_manager.set_sprites_direction(lastDirection)
	set_velocity(vel)
	move_and_slide()
	
func pickup_item(data:Hat_data):
	print("picking " + data.name)
	self.add_new_hat(data)

func add_new_hat(hat_data:Hat_data):
	hat_manager.add_hat(hat_data)
	runSpeed = (1.0 + hat_manager.get_updated_speed_modificator()) * baseRunSpeed
	


