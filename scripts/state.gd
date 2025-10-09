class_name State extends Node

## The neigboring nodes of this node.
@export var neighboring_nodes : Array[State]
## Data within this state upon the enter function
var this_data : Dictionary = {}

## Which way the entity is facing. -1 to move to the left, 1 for right, 0 for no direction.
var direction : int = 0

## Emits when a state is finished and ready to transition to another state.
signal finished(next_state_path: String, data: Dictionary)

## Occurs when the state first enters the tick toop.
func enter(data : Dictionary = {}) -> void:
	pass

## Called by state machine to run on the main tick loop.
func update(_owner, _delta: float) -> void:
	pass 
	
## Called by state machine to run on the physics tick loop.
func _physics_update(_owner, _delta: float) -> void:
	pass

## Sends the finished signal to indicate the end of a state
func exit(next_state: State) -> void:
	# State ends
	#finished.emit(next_state, this_data)
	pass

func change_direction(new_direction: int) -> void:
	direction = new_direction
	if direction == 0: return
	this_data["animation"].flip_h = false if direction == -1 else true

## Probably refactor this into an EnemyState class
func found_player(sight_line : RayCast2D) -> bool:
	if sight_line.is_colliding() && sight_line.get_collider().get_parent() is Player:
		#print("found player")
		this_data["player"] = sight_line.get_collider().get_parent()
		return true
	return false
	
