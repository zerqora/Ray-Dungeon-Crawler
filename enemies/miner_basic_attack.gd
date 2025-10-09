class_name MinerBasicAttack extends State

var cooldown : Timer
@export var hurtbox : Area2D
	
func enter(data : Dictionary = {}) -> void:
	# print("entered attack state")
	this_data = data
	cooldown = this_data["cooldowns"]["basic_attack"]
	# exit if cooldown is still going
	if !cooldown.is_stopped(): 
		finished.emit(neighboring_nodes[0],this_data) 
		return
	cooldown.start()
	
	hurtbox.area_entered.connect(damage_player)
	hurtbox.show()
	
	direction = determine_movement()
	# play attack animation
	this_data["animation"].play("basic_attack")
	# Pivot the hurtbox by 10 in either direction
	hurtbox.position.x = 0 - (10 * (-1 if this_data["animation"].flip_h else 1))
	# wait for the player's animation to finish, and then emit finished signal
	if !this_data["animation"].animation_finished.is_connected(exit):
		this_data["animation"].animation_finished.connect(exit)
	if !this_data["animation"].frame_changed.is_connected(determine_movement):
		this_data["animation"].frame_changed.connect(determine_movement)
	# have a listener for the area2D if it's collided with the player
	
# use the player key in data to deal damage to the player

# TODO: Have the player have invincibility frame. For now, have it as a timer here
var invincibility_frame_duration : float = 1
var timer : float = 0
var hit_player : bool = false
func update(owner, delta: float) -> void:
	direction = determine_movement()
	if hit_player:
		timer += delta
	# Invincibility frames are over
	if timer > invincibility_frame_duration:
		timer = 0
		hit_player = false
	if !hit_player && hurtbox.has_overlapping_areas():
		# the only areas that will be overlapping will be the player's because the mask is listening for the player layer.
		damage_player(hurtbox.get_overlapping_areas()[0])
	# If the invincibility frame is still going
	
	owner.velocity.x = direction * this_data["stats"]["speed"] * 5 * delta
	owner.move_and_slide()

func damage_player(area : Area2D) -> void:
	#print("hit player")
	hit_player = true

func exit(next_node : State = neighboring_nodes[0]) -> void:
	#print("trying to exit attack state")
	hurtbox.hide()
	hurtbox.area_entered.disconnect(damage_player)
	finished.emit(neighboring_nodes[0], this_data)
	
func determine_movement() -> int:
	# if the current frame is index 3, set the velocity depending on the direction of the sprite.
	# If the frame is not 3 yet, return no direction.
	if this_data["animation"].frame >= 3 && this_data["animation"].frame != 5:
		return 1 if this_data["animation"].flip_h else -1
	return 0
		
