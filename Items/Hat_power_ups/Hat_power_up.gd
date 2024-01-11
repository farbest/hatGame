extends Node2D

@export var hat:String
var hat_sprite = Sprite2D.new()

func _init():
	hat_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/hats.png")
	hat_sprite.hframes = 8
	hat_sprite.vframes = 15
	hat_sprite.frame = 16

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		var hat_data:Hat_data = Hat_data.new().set_sprite(hat_sprite)
		var effect = Hat_effect.new()
		effect.speed_multiplier_increase = 2.00
		hat_data.set_effect(effect)
		body.pickup_item(hat_data)
		queue_free()
