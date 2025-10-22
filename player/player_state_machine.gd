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
	
func _transition_to_next_state(next_node : Node, data: Dictionary = {}) -> void:
	#var previous_state_path : String = state.name
	state.exit(next_node)
	state = next_node
	state.enter(data)
	state_text.text = state.name
	state_changed.emit(state)

func _physics_process(delta: float) -> void:
	_handle_input()
	state.update(owner, delta)
	
# Holy moly please refactor
func _handle_input() -> void:
	var stopped_moving: bool = Input.is_action_just_released("LEFT") or Input.is_action_just_released("RIGHT")
	# Feels more predictable to the player if pressing left AND right cancelled out movement.
	var cancelled_out_direction : bool = Input.is_action_pressed("LEFT") and Input.is_action_pressed("RIGHT")
	if state != $Falling && Input.is_action_just_pressed("DASH"):
		state.finished.emit($ChargeDash, state.this_data)
	if state != $Dash && Input.is_action_just_released("DASH"):
		state.finished.emit($Idle, state.this_data)
	if state != $Dash && state != $ChargeDash:
		if !owner.is_on_floor():
			state.finished.emit($Falling, state.this_data)
		elif stopped_moving or cancelled_out_direction:
			state.finished.emit($Idle, state.this_data)
		elif (Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT")):
			state.finished.emit($Move, state.this_data)
	if Input.is_action_just_pressed("INTERACT"):
		EventBus.on_interaction_button_pressed.emit()
	if Input.is_action_just_pressed("ATTACK"):
		pass
	
func fill_data() -> void:
	data = {
		"stats" : owner.player_stats,
		"animation" : animation,
		"spawn_point" : owner.global_position,
		"cooldowns" : owner.attack_cooldowns,
		"dash_streak" : 0
	}
