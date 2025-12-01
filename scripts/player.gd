class_name Player extends CharacterBody2D
# Eventually create a state machine to control what happens to inputs. Getting the basics down and changing it later.

enum MOUSE_MODE{
	DASH_SELECTOR,
	BASIC_ATTACK
}

var current_mouse_mode = MOUSE_MODE.BASIC_ATTACK

@onready var attack_slots = {
	"FlameFist" = preload("res://player/flame_fist.tscn")
}
@onready var attack_cooldowns = {
	"FlameFist" = attack_slots["FlameFist"],
	"Dash" = null
}
@onready var animation = $Sprite2D
@export var player_stats : PlayerStats
@export var hitbox : Area2D
@export var state_machine : PlayerStateMachine
# Player Stats
var speed: int = 5000
var gravity: int = 5000
@onready var max_hp : int = player_stats.hp
@onready var hp : int = player_stats.hp

var knockback_received : Vector2 = Vector2(0,0)
var knockback_duration : float = .25
var knockback_timer : float = 0
var friction : float = .7

var invincible : bool = false
var i_frame_timer : float = 0
var i_frame_duration : float = .25

signal damaged(area : Area2D, knockback : Vector2)
signal take_knockback(amount : Vector2)
signal start_cooldown(ability_name : String)

func _ready() -> void:
	animation.play("idle")
	state_machine.state_changed.connect(_on_state_changed)
	start_cooldown.connect(on_cooldown_started)
	damaged.connect(take_damage)
	take_knockback.connect(_deal_knockback)
	var values : Array = attack_slots.values()
	var cooldowns : Array = $Timers.get_children()
	for cooldown in cooldowns:
		cooldown.start()
	
func is_on_cooldown(ability_name : String) -> bool:
	# Returns if this ability is on cooldown
	var path : String = "Timers/" + ability_name + "Cooldown"
	var cooldown : Timer = get_node(path)
	#print(path, " ", cooldown)
	return !cooldown.is_stopped()

func on_cooldown_started(ability_name : String) -> void:
	var path : String = "Timers/" + ability_name + "Cooldown"
	var cooldown : Timer = get_node(path)
	cooldown.start()
	#print("Cooldown " + ability_name + " started")
	
	
# Deal with enabling and disabling collisions and area2D nodes
func _on_state_changed(state : State) -> void:
	match state.name:
		"Dash":
			Camera.zoom_out_for_seconds(Vector2(4.5, 4.5), .15)
			Camera.zoom_to_default(.5)
			start_cooldown.emit("Dash")


func take_damage(area : Area2D, knockback) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.RED, .1)
	tween.tween_property(self, "modulate", Color.WHITE, .1)
	if invincible:
		return
	if area.owner is not Entity: 
		printerr("Not an entity. Cannot damage the player.")
		return
	else: pass#print("hit")
	var entity : Entity = area.owner
	var damage = entity.entity_stats.damage
	hp -= damage
	_deal_knockback(knockback)
	enable_invincibility()
	_check_death()


func heal_health(amount : int) -> void:
	pass

func _update_invincibility() -> void:
	i_frame_timer += get_process_delta_time()
	if invincible and i_frame_timer > i_frame_duration:
		invincible = false
		i_frame_timer = 0
		#print("Invinciblity is over")
		
func enable_invincibility() -> void:
	invincible = true

func _check_death() -> void:
	if hp <= 0:
		EventBus.player_died.emit()
		
func _deal_knockback(knockback : Vector2 = velocity * -1) -> void:
	knockback_received = knockback * 500
	#print("Knockback received: ", knockback)

func _physics_process(delta: float) -> void:
	_handle_input()
	_update_invincibility()
	if knockback_timer < knockback_duration and (knockback_received.x > 0 or knockback_received.x < 0):
		knockback_timer += delta
		velocity += knockback_received * delta
		knockback_received *= friction
		move_and_slide()
		#print("Advancing Knockback Timer ")
	elif knockback_timer > knockback_duration:
		knockback_timer = 0
		knockback_received = Vector2(0,0)
		#print("Knockback Over")
		
# Holy moly please refactor
func _handle_input() -> void:
	var stopped_moving: bool = Input.is_action_just_released("LEFT") or Input.is_action_just_released("RIGHT")
	# Feels more predictable to the player if pressing left AND right cancelled out movement.
	var cancelled_out_direction : bool = Input.is_action_pressed("LEFT") and Input.is_action_pressed("RIGHT")
	# Start the charge dash state
	if !is_on_cooldown("Dash") && Input.is_action_just_pressed("DASH"):
		state_machine.state.finished.emit("ChargeDash", state_machine.state.this_data)
	# End The Dash State early
	if state_machine.state != $StateMachine/Dash && Input.is_action_just_released("DASH"):
		state_machine.state.finished.emit("Idle", state_machine.state.this_data)
	# If not charging dash or dashing, handle any other movement
	if state_machine.state != $StateMachine/Dash && state_machine.state != $StateMachine/ChargeDash:
		if !is_on_floor():
			state_machine.state.finished.emit("Falling", state_machine.state.this_data)
		elif stopped_moving or cancelled_out_direction:
			state_machine.state.finished.emit("Idle", state_machine.state.this_data)
		elif (Input.is_action_pressed("LEFT") or Input.is_action_pressed("RIGHT")):
			state_machine.state.finished.emit("Move", state_machine.state.this_data)
	# The interact signal is emitted (for doors and stuff)
	if Input.is_action_just_pressed("INTERACT"):
		EventBus.on_interaction_button_pressed.emit()
	if Input.is_action_just_pressed("ATTACK"):
		var attack : Attack = attack_slots["FlameFist"].instantiate()
		add_child(attack)
		attack.spawn(Vector2(self.global_position.x + (20 if $Sprite2D.flip_h else -20), self.global_position.y))
		attack.flip_animation(!$Sprite2D.flip_h)
#func _attempt_to_spawn_attack(attack: String) -> void:
	#var attack_selected : Attack = attack_slots[attack]
	#if attack_selected.visible: return
	#attack_selected.global_position = Vector2(global_position.x + (direction * 10), global_position.y - 20)
	#attack_selected.spawn()
