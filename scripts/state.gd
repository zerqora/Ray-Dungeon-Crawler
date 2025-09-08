class_name State extends Node

## The next node of the behavior tree.
@export var next_node : State
## Data within this state upon the enter function
var this_data : Dictionary = {}

## Emits when a state is finished and ready to transition to another state.
signal finished(next_state_path: String, data: Dictionary)

## Occurs when the state first enters the tick toop.
func enter(previous_state_path : String, data : Dictionary = {}) -> void:
	pass

## Called by state machine to run on the main tick loop.
func update(_owner, _delta: float) -> void:
	pass 
	
## Called by state machine to run on the physics tick loop.
func _physics_update(_owner, _delta: float) -> void:
	pass

## Sends the finished signal to indicate the end of a state
func exit() -> void:
	# State ends
	finished.emit(next_node, this_data)
