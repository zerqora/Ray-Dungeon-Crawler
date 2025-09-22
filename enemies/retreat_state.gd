class_name RetreatState extends State

# For now will always be spawn
var direction_to_destination : int

func enter(data: Dictionary = {}) -> void:
	#print("entered retreat state")
	this_data = data

func update(owner, delta : float) -> void:
	direction_to_destination = determine_direction(owner)
	owner.velocity.x = direction_to_destination * this_data["stats"].speed * delta
	if (owner.global_position - this_data["spawn_point"]).length() < 10:
		print("reached spawn point")
		finished.emit(neighboring_nodes[0], this_data)
	this_data["animation"].flip_h = true if direction_to_destination > 0 else false
	owner.move_and_slide()
	
func determine_direction(owner) -> int:
	return 1 if this_data["spawn_point"].x - owner.global_position.x > 0 else -1
