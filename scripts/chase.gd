class_name ChaseState extends State

var speed : int
var gravity : int = 5000
var direction : int = 1
@export var max_distance : int

func enter(data : Dictionary = {}) -> void:
	this_data = data
	this_data["animation"].play("chase")
	speed = this_data["stats"].speed
	# print("Entered Chase State")

# update function should check if the player is still in the sight line.
# if they aren't, patrol the area a little bit before going back to the original spot.
# if the entity is close enough to the player, play an attack, and then retreat backwards.
func update(owner, delta: float) -> void:
	if this_data["player"].global_position.x - owner.global_position.x > 0:
		# player is on the right
		this_data["animation"].flip_h = true
		direction = 1 
	else:
		# player is on the left
		this_data["animation"].flip_h = false
		direction = -1
	owner.velocity.x = speed * direction * delta
	check_distance_from_spawn()
	look_for_player(owner)
	owner.move_and_slide()
	
func look_for_player(owner) -> void:
	# Close enough to the player
	if abs(this_data["player"].global_position.x - owner.global_position.x) < 30:
		# Stop moving
		owner.velocity.x = 0
		exit(neighboring_nodes[1])

func check_distance_from_spawn() -> void:
	if this_data["spawn_point"].x - owner.global_position.x > max_distance:
		print("too far away from spawn. I'm just gonna head back.")
		finished.emit(neighboring_nodes[2], this_data)
		
