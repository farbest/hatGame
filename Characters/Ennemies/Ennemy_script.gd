extends Abstract_character

func _on_area_2d_area_entered(_area):
	self.take_damage(1)
	
func take_damage(amount:int):
	self.health_points -= 1
	self.die_if_dead()
	
func is_dead()->bool:
	return self.health_points <= 0

func die_if_dead():
	if self.is_dead():
		self.die() 
		
func die():
	queue_free()
