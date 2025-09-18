class_name StateMachine extends Node

## Initial state of the state machine. 
@export var initial_state : State = null
@export var animation : AnimatedSprite2D
@onready var state : State = (func get_initial_state() -> State: return initial_state if initial_state != null else get_child(0)).call()
@export var sight_raycast : SightLine
@export var cooldowns : Array[Timer]
@export var attacks : Array[Area2D]

func _ready() -> void:
	# Give every state a reference to the state machine.
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	for attack in attacks:
		attack.hide()
	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
	await owner.ready
	var data : Dictionary = {
		"stats" : owner.entity_stats,
		"animation" : animation,
		"spawn_point" : owner.global_position,
		"sight" : sight_raycast,
		"cooldowns" : {
			"basic_attack" : cooldowns[0]
		}
	}
	state.enter(data)
	#target = get_tree().get_nodes_in_group("Player")[0]
	#print("Player is being tracked with it's node", target)

func _transition_to_next_state(next_node : Node, data: Dictionary = {}) -> void:
	#var previous_state_path : String = state.name
	# state.exit()
	state = next_node
	state.enter(data)

func update(delta: float) -> void:
	state.update(owner, delta)
	sight_raycast.target_position.x = abs(sight_raycast.target_position.x) * (-1 if animation.flip_h == false else 1)
	if not owner.is_on_floor() : owner.velocity.y = 5000 * delta
	
