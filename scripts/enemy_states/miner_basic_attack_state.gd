class_name MinerBasicAttack extends State

var cooldown : Timer
@export var hurtbox : Area2D

func enter(data : Dictionary = {}) -> void:
	# print("entered attack state")
	this_data = data
	cooldown = this_data["cooldowns"]["basic_attack"]
	# exit if cooldown is still going
	if !cooldown.is_stopped(): 
		finished.emit(neighboring_nodes[0].name,this_data) 
		return
	cooldown.start()
	
	hurtbox.show()
	hurtbox.set_deferred("monitorable", true)
	
	direction = determine_movement()
	# play attack animation
	this_data["animation"].play("basic_attack")
	# wait for the player's animation to finish, and then emit finished signal
	if !this_data["animation"].animation_finished.is_connected(func(): finished.emit(neighboring_nodes[0].name, this_data)):
		this_data["animation"].animation_finished.connect(func(): finished.emit(neighboring_nodes[0].name,this_data))
	
	# have a listener for the area2D if it's collided with the player
	
# use the player key in data to deal damage to the player

var hurtbox_hits : Array[Area2D]

func update(owner, delta: float) -> void:
	owner.velocity.x = direction * this_data["stats"]["speed"] * 5 * delta
	owner.move_and_slide()
	hurtbox_hits = hurtbox.get_overlapping_areas()
	if hurtbox_hits.size() > 0:
		# the only areas that will be overlapping will be the player's because the mask is listening for the player layer.
		var player : Player = hurtbox_hits[0].owner
		player.damaged.emit(hurtbox, owner.velocity)
		

func exit(next_node : State = neighboring_nodes[0]) -> void:
	#print("trying to exit attack state")
	hurtbox.set_deferred("monitorable", false)
	hurtbox.hide()
	
func determine_movement() -> int:
	return 1 if this_data["animation"].flip_h else -1
