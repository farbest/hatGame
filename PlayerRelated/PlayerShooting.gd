extends KinematicBody2D

func _physics_process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		print("pew pew")

