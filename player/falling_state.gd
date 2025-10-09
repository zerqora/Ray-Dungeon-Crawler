class_name FallState extends State

func enter(data : Dictionary = {}) -> void:
	this_data = data
	
func update(owner, delta : float) -> void:
	if owner.is_on_floor():
		# Exit to idle state
		finished.emit(neighboring_nodes[0], this_data)
	if Input.is_action_pressed("LEFT"):
		change_direction(-1)
	if Input.is_action_pressed("RIGHT"):
		change_direction(1)
	owner.velocity.y = 5000 * delta
	owner.velocity.x = direction * (this_data["stats"].speed / 2) * delta 
	owner.move_and_slide()
	
