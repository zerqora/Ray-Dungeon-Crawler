class_name StateMachine extends Node

## Initial state of the state machine. 
@export var initial_state : State = null
@export var animation : AnimatedSprite2D
@onready var state : State = (func get_initial_state() -> State: return initial_state if initial_state != null else get_child(0)).call()
@export var sight_raycast : SightLine
@export var cooldowns : Array[Timer]
@export var attacks : Array[Area2D]

## Dictionary that holds information to be passed along each state.
var data : Dictionary

signal damaged(what : Area2D)

var state_text : Label
var current_invincibility = false

func _ready() -> void:
	damaged.connect(on_hitbox_triggered)
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

## Emitted on the "finished" signal. Transitions to the next state through the next_node parameter. 
func _transition_to_next_state(next_node : StringName, data: Dictionary = {}) -> void:
	#var previous_state_path : String = state.name
	var next_state : State
	var path : NodePath = str(next_node)
	next_state = get_node(path)
	state.exit(next_state)
	state = next_state
	state.enter(data)

func update(delta: float) -> void:
	state.update(owner, delta)
	sight_raycast.target_position.x = abs(sight_raycast.target_position.x) * (-1 if animation.flip_h == false else 1)
	if not owner.is_on_floor() : owner.velocity.y = 5000 * delta

## Connected to the damaged signal. 
## No matter what state, if the entity is attacked, deal knockback to [param what] based on the player's velocity and exit to the hurt state. 
func on_hitbox_triggered(what : Area2D) -> void:
	if state == $Hurt:
		#print("Cannot exit to the hurt state because I'm already in it.")
		return
	if is_invincible(): 
		#print("Is invincible")
		return
	#print("Going into the Hurt State")
	# Deal knockback here because we have the [what] parameter.
	# TODO : fix with velocity instead maybe
	deal_knockback(1000)
	
	state.this_data["player"] = what.owner if what.owner is Player else null
	if state.this_data["player"] == null: 
		printerr("Player not found.")
		return
	state.finished.emit("Hurt", state.this_data)

## The [param source] will apply an [param amount] of knockback to the [param] who paramater.
func deal_knockback(amount : int) -> void:
	var knockback_direction : Vector2
	knockback_direction = (owner.velocity).normalized()
	owner.velocity = knockback_direction * amount
	owner.move_and_slide()

## Fills the starting data for this type of entity. 
func fill_data() -> void:
	data = {
		"stats" : owner.entity_stats,
		"animation" : animation,
		"spawn_point" : owner.global_position,
		"sight" : sight_raycast,
		"cooldowns" : {
			"basic_attack" : cooldowns[0]
		}
	}

func set_invincibility(is_invincible : bool) -> void:
	current_invincibility = is_invincible

func is_invincible() -> bool:
	return current_invincibility
