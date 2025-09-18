class_name ChaseState extends State

var speed : int
var gravity : int = 5000
var direction : int = 1

func enter(data : Dictionary = {}) -> void:
	this_data = data
	this_data["animation"].play("chase")
	this_data["sight"].target_position.x *= 1.5
	speed = this_data["stats"].speed
	print("Entered Chase State")

# update function should check if the player is still in the sight line.
# if they aren't, patrol the area a little bit before going back to the original spot.
# if the entity is close enough to the player, play an attack, and then retreat backwards.
func update(owner, delta: float) -> void:
	look_for_player(owner)
	if this_data["player"].global_position.x - owner.global_position.x > 0:
		# player is on the right
		this_data["animation"].flip_h = true
		direction = 1 
	else:
		# player is on the left
		this_data["animation"].flip_h = false
		direction = -1
	owner.velocity.x = speed * direction * delta
	
func look_for_player(owner) -> void:
	if abs(this_data["player"].global_position.x - owner.global_position.x) < 20:
		exit(neighboring_nodes[1])
