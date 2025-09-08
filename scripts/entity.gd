class_name Entity extends CharacterBody2D

@export var entity_stats : EntityStats # need to make entity stats
@export var hitbox : Area2D
@export var hurtbox : Area2D
@export var state_machine : StateMachine
@export var animation_player : AnimatedSprite2D

enum DIRECTIONS {
	NONE = 0,
	LEFT = -1,
	RIGHT = 1
}

var gravity : int
var speed : int
var current_hp : int
var damage : float
var direction : int = DIRECTIONS.NONE
var target : Player

func _ready() -> void:
	animation_player.play("idle")
	gravity = entity_stats.gravity
	speed = entity_stats.speed
	current_hp = entity_stats.hp
	damage = entity_stats.damage

func _physics_process(delta: float) -> void:
	state_machine.update(delta)
	
