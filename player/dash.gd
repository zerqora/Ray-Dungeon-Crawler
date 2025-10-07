class_name DashState extends State

var speed : int = 0
var upward_force : float = 0
var timer : float = 0
var applied_force_duration : float = .5
var acceleration : float = 500

func enter(data : Dictionary = {}) -> void:
	timer = 0
	this_data = data
	speed = this_data["stats"].speed
	print("dashing")
	
func update(owner, delta: float) -> void:
	timer += delta
	if timer > applied_force_duration:
		finished.emit(neighboring_nodes[0], this_data)
		if !owner.is_on_floor():
			finished.emit(neighboring_nodes[0], this_data)
	else:
		owner.velocity.move_toward(owner.velocity, acceleration * timer)
		owner.move_and_slide()

func on_collision() -> void:
	# apply a force upwards, then emit the finished signal to falling.
	# the player data should hold a key to a streak value, which when it increases, it divides the upward force.
	# streak should decrease at some point (or reset)
	this_data["dash_streak"] = this_data["dash_streak"] + 1
	upward_force = -100000 / this_data["dash_streak"]
