class_name PatrolState extends State

var direction : int
## The maximum distance in both directions from spawn that the entity can patrol.
@export var maximum_distance : int = 20

func enter(data : Dictionary = {}) -> void:
	this_data = data
	data["animation"].play("chase")
	direction = 1 if data["animation"].flip_h == true else -1
	# print("In Patrol State")

func turn() -> void:
	match direction:
		-1:
			# Look left
			this_data["animation"].flip_h = false
		0:
			# Go back to idle state
			finished.emit(neighboring_nodes[0], this_data)
		1:
			# Look right
			this_data["animation"].flip_h = true
		_:
			printerr("Direction is an invalid integer.")
	# this_data["sight"].target_position = abs(this_data["sight"].target_position.x) * (-1 if this_data["animation"].flip_h == false else 1)
	
var turn_seconds := randf_range(0, 4)
var timer : float = 0;

func update(owner, delta : float) -> void:
	timer += delta
	if timer > turn_seconds:
		timer = 0
		turn_seconds = randf_range(0,4)
		direction = randi_range(-1, 1)
		turn()
	# Entity is too far from spawn. turn the other way
	if abs(this_data["spawn_point"].x - owner.global_position.x) > maximum_distance:
		direction *= -1
		turn()
		print("I'm straying too far away from spawn. I'm going to head the opposite way.")
	owner.velocity.x = direction * this_data["stats"].speed * delta
	owner.move_and_slide()
	if found_player(this_data["sight"]):
		finished.emit(neighboring_nodes[1], this_data)
		
		
