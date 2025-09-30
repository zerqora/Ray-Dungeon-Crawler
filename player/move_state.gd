class_name MoveState extends State

func enter(data : Dictionary= {}) -> void:
	this_data = data

func update(owner, delta : float) -> void:
	owner.velocity.x = direction * this_data["stats"].speed * delta
	if !owner.is_on_floor():
		# Should exit to falling state
		owner.velocity.y = 5000 * delta
	owner.move_and_slide()
