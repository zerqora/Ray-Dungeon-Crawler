class_name PlayerStateMachine extends Node

@export var initial_state : State = null
@export var animation : AnimatedSprite2D
@export var attacks : Array[Area2D]
@onready var state : State = (func get_initial_state() -> State: return initial_state if initial_state != null else get_child(0)).call()

# Created a whole other class for the player because of the inputs. 
# Also, it won't be a nightmare to try to fit the player into the entity's code

var data : Dictionary
var state_text : Label

signal state_changed(state : State)

func _ready() -> void:
	# Give every state a reference to the state machine.
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)
	for attack in attacks:
		attack.hide()
	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
	await owner.ready
	
	fill_data()
	state_text = owner.get_node("StateDebugText")
	state.enter(data)
	#target = get_tree().get_nodes_in_group("Player")[0]
	#print("Player is being tracked with it's node", target)
	
func _transition_to_next_state(next_node : StringName, data: Dictionary = {}) -> void:
	#var previous_state_path : String = state.name
	var next_state : State
	var path : NodePath = str(next_node)
	next_state = get_node(path)
	state.exit(next_state)
	state = next_state
	state.enter(data)


	state_text.text = state.name
	state_changed.emit(state)

func _physics_process(delta: float) -> void:
	state.update(owner, delta)
	
func fill_data() -> void:
	data = {
		"stats" : owner.player_stats,
		"animation" : animation,
		"spawn_point" : owner.global_position,
		"cooldowns" : owner.attack_cooldowns,
		"dash_streak" : 0
	}
