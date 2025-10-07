class_name MoveState extends State

var speed : int = 0
func enter(data : Dictionary = {}) -> void:
	this_data = data
	speed = this_data["stats"].speed
	this_data["animation"].play("run")

func update(owner, delta : float) -> void:
	if Input.is_action_pressed("LEFT"):
		change_direction(-1)
	elif Input.is_action_pressed("RIGHT"):
		change_direction(1)
	owner.velocity.x = direction * speed * delta
	owner.move_and_slide()
