class_name MinerBasicAttack extends State

var cooldown : Timer
@export var hurtbox : Area2D

func enter(data : Dictionary = {}) -> void:
	print("entered attack state")
	this_data = data
	cooldown = this_data["cooldowns"]["basic_attack"]
	# exit if cooldown is still going
	if !cooldown.is_stopped(): 
		finished.emit(this_data, neighboring_nodes[0]) 
		return
	cooldown.start()
	hurtbox.area_entered.connect(damage_player)
	hurtbox.show()
	# play attack animation
	# wait for the player's animation to finish, and then emit finished signal
	# have a listener for the area2D if it's collided with the player
	
# use the player key in data to deal damage to the player

func update(owner, delta: float) -> void:
	if hurtbox.has_overlapping_areas():
		damage_player(hurtbox.get_overlapping_areas()[0])
func damage_player(area : Area2D) -> void:
	print("hit player")
	pass
