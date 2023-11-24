extends CharacterBody2D

var velt = Vector2()
var speed = 10

@export var damage = 1

@onready var hitbox = $Hitbox

func _ready():
	hitbox.connect("area_entered",_on_impact.bind())

func _physics_process(_delta):
	var angle = get_global_transform().get_rotation()
	velt = Vector2(cos(angle), sin(angle))
	velt = move_and_collide(velt*speed)

func _on_impact(_area: Area2D):
	queue_free()

	

