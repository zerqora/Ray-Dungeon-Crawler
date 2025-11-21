class_name Entity extends CharacterBody2D

@export var entity_stats : EntityStats 
@export var hitbox : Area2D
@export var state_machine : StateMachine

var invincible : bool = false
var invis_frames : float = .5
var timer : float = 0

var target : Player

@onready var max_hp : int = entity_stats.hp
@onready var current_hp : int = entity_stats.hp

signal damaged(area : Area2D)

func _ready() -> void:
	damaged.connect(func(area : Area2D) -> void: state_machine.damaged.emit(area))

func _physics_process(delta: float) -> void:
	state_machine.update(delta)
	# The entity's hurt state will determine if invis frames will apply.
	# TODO: Probably refactor the invincibility code
	invincible = state_machine.is_invincible()
	if not invincible:
		timer += delta
	if timer > invis_frames:
		invincible = false
	#if invincible && hitbox.area_entered.is_connected(func(area: Area2D): state_machine.damaged.emit(area)):
		#hitbox.area_entered.disconnect(func(area: Area2D): state_machine.damaged.emit(area))
	#elif !hitbox.area_entered.is_connected(func(area: Area2D): state_machine.damaged.emit(area)):
		#hitbox.area_entered.connect(func(area: Area2D): state_machine.damaged.emit(area))

	
func update_hp(amount : int) -> void:
	current_hp = amount

func decrement_hp(amount : int) -> void:
	current_hp -= amount

func increment_hp(amount :  int) -> void:
	current_hp += amount
