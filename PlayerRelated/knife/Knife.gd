extends KinematicBody2D

var velocity = Vector2()
var speed = 10

export (int)var damage = 1

onready var hitbox = $Hitbox

func _ready():
	hitbox.area_shape_entered.connect("test")

func _physics_process(_delta):
	var angle = get_global_transform().get_rotation()
	velocity = Vector2(cos(angle), sin(angle))
	velocity = move_and_collide(velocity*speed)

func test():
	print()

	

