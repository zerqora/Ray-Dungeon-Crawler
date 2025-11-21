class_name ChargeDashState extends State

# When the player dashes, Ray will head towards the mouse. If he collides with an enemy, he will bounce into the air, 
# and the player will have an opportunity to keep dashing to another enemy. 

var speed : float = 0
var mouse_position : Vector2
var mouse_located : bool = false

func enter(data : Dictionary = {}) -> void:
	this_data = data
	speed = this_data["stats"].speed / 10
	#print("charging dash")

# Need to make the dash move towards the enemy closest to the mouse
func update(owner, delta : float) -> void:
	owner.velocity = Vector2(0,0)
	owner.velocity.x = direction * speed * delta
	_handle_input()
	if !owner.is_on_floor():
		# Player is still in the air, cannot charge a dash
		finished.emit(neighboring_nodes[0].name, this_data)
	if mouse_located:
		# Player clicked to where they wanted to dash, set the velocity towards the mouse
		owner.velocity.x = find_direction_to_mouse(mouse_position) * this_data["stats"].speed * 3 * delta
		# Exit to the dash state
		finished.emit(neighboring_nodes[0].name, this_data)
	owner.move_and_slide()

func _handle_input() -> void:
	find_direction_to_mouse(owner.get_global_mouse_position())
	if Input.is_action_just_pressed("ATTACK"):
		mouse_located = true
		mouse_position = owner.get_global_mouse_position()
		#print("mouse located")

func find_direction_to_mouse(mouse_position : Vector2) -> int:
	var mouse_direction : Vector2 = owner.global_position.direction_to(mouse_position).normalized()
	change_direction(1 if mouse_direction.x > 0 else -1)
	return direction

func exit(next_state : State) -> void:
	mouse_located = false
