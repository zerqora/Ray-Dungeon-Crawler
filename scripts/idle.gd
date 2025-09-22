class_name IdleState extends State

@export var sight_line : SightLine

var player_seen : bool
	
func enter(data: Dictionary = {}) -> void:
	this_data = data
	this_data["animation"].play("idle")
	print("idle state")
## Random float that changes everytime the entity successfully turns
var turn_when_seconds : float = randf_range(1, 5)
var chance_to_patrol : float = randf_range(0,1)
## Time since the last time the entity has turned. 
var timer : float = 0
func update(owner, delta: float) -> void:
	# Decide whether to just turn OR patrol around the area
	if timer > turn_when_seconds:
		turn_when_seconds = randf_range(1, 5)
		timer = 0
		# if over 50%, exit to patrol node
		if chance_to_patrol > .5:
			exit(neighboring_nodes[ceil(chance_to_patrol)])
		else: 
			turn(owner)
		chance_to_patrol = randf_range(0,1)
	timer += delta
	look_for_player()

func look_for_player() -> void:
	if sight_line.is_colliding() && sight_line.get_collider().get_parent() is Player:
		print("found player")
		this_data["player"] = sight_line.get_collider().get_parent()
		finished.emit(neighboring_nodes[0], this_data)
		
func turn(owner) -> void:
		owner.animation_player.flip_h = false if owner.animation_player.flip_h else true
		sight_line.target_position.x *= -1
