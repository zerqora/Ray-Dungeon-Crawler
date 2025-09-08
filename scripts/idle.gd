class_name IdleState extends State

@export var sight_line : SightLine

var player_seen : bool
	
func enter(previous_state_path : String, data: Dictionary = {}) -> void:
	this_data = data
	this_data["animation"].play("idle")

## Random float that changes everytime the entity successfully turns
var turn_when_seconds : float = randf_range(1, 5)
## Time since the last time the entity has turned. 
var turn_in_seconds : float = 0

func update(owner, delta: float) -> void:
	# Turn around and look for the player in that direction
	if turn_in_seconds > turn_when_seconds:
		turn_when_seconds = randf_range(1, 5)
		turn_in_seconds = 0
		owner.animation_player.flip_h = false if owner.animation_player.flip_h else true
		sight_line.target_position.x *= -1
	turn_in_seconds += delta
	look_for_player()

func look_for_player() -> void:
	player_seen = sight_line.update()
	if player_seen:
		print("Started to chase")
		this_data["player"] = sight_line.get_collider()
		this_data["sight"] = sight_line
		exit()
