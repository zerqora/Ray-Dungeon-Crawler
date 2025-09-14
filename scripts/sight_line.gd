class_name SightLine extends RayCast2D

func update() -> bool:
	if is_colliding(): 
		#print("colliding")
		return true
	return false
	
