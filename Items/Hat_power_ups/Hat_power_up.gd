extends Node2D

enum HAT_TYPE{
	BARBARIAN, 
	CLERIC, 
	FEATHER,
	KNIGHT, 
	PURPLE, 
	TRICORN,
	WIZARD,
	}
	
@onready var sprite = $Sprite2D
@export var hat_type: HAT_TYPE
var hat_data = Hat_data.new()

func get_hat_data(hat_type:HAT_TYPE):
	
	var hat_data:Hat_data = Hat_data.new()
	var effect = Hat_effect.new()
	var local_sprite = Sprite2D.new()
	
	var local_name = ""
	
	match hat_type:
		HAT_TYPE.BARBARIAN:
			# Effect modification
			local_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/barbarian.png")
			local_name = "barbarian"
		HAT_TYPE.CLERIC:
			# Effect modification
			local_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/cleric.png")
			local_name = "cleric"
		HAT_TYPE.FEATHER:
			# Effect modification
			local_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/feather.png")
			local_name = "feather"
		HAT_TYPE.KNIGHT:
			# Effect modification
			local_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/knight.png")
			local_name = "knight"
		HAT_TYPE.PURPLE:
			# Effect modification
			local_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/purple.png")
			local_name = "purple"
		HAT_TYPE.TRICORN:
			# Effect modification
			local_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/tricorn.png")
			local_name = "tricorn"
		HAT_TYPE.WIZARD:
			# Effect modification
			local_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/wizard.png")
			local_name = "wizard"
		_:
			# Effect modification
			local_sprite.texture = preload("res://Items/Hat_power_ups/Hat_sprites/wizard.png")
			local_name = "wizard"
	return self.create_hat_data(local_name, effect,local_sprite)
	
func create_hat_data(name,effect,sprite):
	var hat_data = Hat_data.new()
	hat_data.set_name(name)
	hat_data.set_effect(effect)
	hat_data.set_sprite(sprite)
	
	return hat_data

func _ready():
	self.hat_data = self.get_hat_data(self.hat_type)
	
	self.hat_data.sprite.hframes = 8
	self.hat_data.sprite.vframes = 2
	self.hat_data.sprite.frame = 1
	
	sprite = self.hat_data.sprite.duplicate()

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		body.pickup_item(self.hat_data)
		queue_free()
		
		
