class_name ChaseState extends State

var speed : int
var gravity : int = 5000
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
	if owner.target.global_position.x - owner.global_position.x > 0:
		# player is on the right
		change_direction(1)
	else:
		# player is on the left
		change_direction(-1)
	# If too far away from spawn and cannot see the player, retreat
	if _distance_from_spawn() > max_distance && (abs(owner.target.global_position.x - owner.global_position.x)) > max_distance:
		finished.emit(neighboring_nodes[2].name, this_data)
	owner.velocity.x = speed * direction * delta
	look_for_player(owner)
	owner.move_and_slide()

## Decides whether or not to exit to an attack state based on how far the owner is from the player.
func look_for_player(owner) -> void:
	var distance : float = abs(owner.target.global_position.x - owner.global_position.x)
	# If too close to the player, back up
	if distance < 40:
		owner.velocity.x *= -1
		#print("too close to the player")
		return
	# Close enough to the player to damage
	if distance < 50:
		finished.emit(neighboring_nodes[1].name, this_data)
	
func _distance_from_spawn() -> float:
	return this_data["spawn_point"].x - owner.global_position.x
		
