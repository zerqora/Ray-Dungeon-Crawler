class_name DashState extends State

# When the player dashes, Ray will head towards the mouse. If he collides with an enemy, he will bounce into the air, 
# and the player will have an opportunity to keep dashing to another enemy. 

var speed : int = 0
var mouse_position : Vector2
var upward_force : int = 0
var applied_force_duration : float = .5
var collided : bool = false


func enter(data : Dictionary = {}) -> void:
	this_data = data
	speed = this_data["stats"].speed / 2
	# Find how to get the mouse position only once
	mouse_position = get_viewport().get_global_mouse_position()
	
var timer : float = 0
# Need to make the dash move towards the enemy closest to the mouse
func update(owner, delta : float) -> void:
	owner.velocity = find_direction_to_mouse(mouse_position)
	owner.velocity.y = upward_force * delta
	if collided:
		timer += delta
	if timer > applied_force_duration:
		# Exit to the falling node
		finished.emit(neighboring_nodes[0], this_data)
	owner.move_and_slide()

func on_collision() -> void:
	# apply a force upwards, then emit the finished signal to falling.
	# the player data should hold a key to a streak value, which when it increases, it divides the upward force.
	# streak should decrease at some point (or reset)
	this_data["dash_streak"] = this_data["dash_streak"] + 1
	upward_force = -1000 / this_data["dash_streak"]


# Should make Ray move to wherever the mouse is, including the angle.
func find_direction_to_mouse(mouse_position : Vector2) -> Vector2:
	return owner.global_position.direction_to(mouse_position)
