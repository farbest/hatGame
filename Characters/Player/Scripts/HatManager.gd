extends Marker2D
class_name HatManager

var hat_list: Array[Hat_data] = []

func add_hat(hat_data:Hat_data):
	hat_list.append(hat_data)
	self.add_child(hat_data.sprite)
	
	hat_data.sprite.flip_h = true

func get_last_hat_sprite()->Sprite2D:
	if len(hat_list) > 0:
		return hat_list[-1].sprite

	return null
	
func set_sprites_direction(lookingDirection:Vector2):
	var to_flip = lookingDirection.x < 0
	for hat in hat_list:
		hat.sprite.flip_h = to_flip
		
func get_updated_speed_modificator():
	var speed_modif:float = 0.0
	for hat in hat_list:
		if(hat.effect.speed_multiplier_increase):
			speed_modif += hat.effect.speed_multiplier_increase
	return speed_modif

	
	



