extends Abstract_character

func _on_area_2d_area_entered(_area):
	self.take_damage(1)
	
func take_damage(amount:int):
	self.health_points -= amount
	if self.should_die():
		self.die() 
	
func should_die()->bool:
	return self.health_points <= 0
		
func die():
	queue_free()
