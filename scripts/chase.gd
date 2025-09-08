class_name ChaseState extends State

var speed : int = 350
var direction : int= -1
var gravity : int = 500

func enter(previous_path : String, data : Dictionary = {}) -> void:
	this_data = data
	data["animation"].play("chase")
	print("Entered Chase State")

# update function should check if the player is still in the sight line.
# if they aren't, patrol the area a little bit before going back to the original spot.
# if the entity is close enough to the player, play an attack, and then retreat backwards.
func update(owner, delta: float) -> void:
	look_for_player()
	if this_data["player"].global_position.x - owner.global_position.x > 0:
		# player is on the right
		this_data["animation"].flip_h = true
		this_data["sight"].target_position.x = abs(this_data["sight"].target_position.x)
		direction = 1 
	else:
		# player is on the left
		this_data["animation"].flip_h = false
		this_data["sight"].target_position.x = abs(this_data["sight"].target_position.x) * -1
		direction = -1
	owner.velocity.x = speed * direction * delta
	if not owner.is_on_floor() : owner.velocity.y = gravity * delta
	owner.move_and_slide()
	
func look_for_player() -> void:
	if this_data["sight"].is_colliding() == false:
		exit()
