class_name Entity extends CharacterBody2D

@export var entity_stats : EntityStats # need to make entity stats
@export var hitbox : Area2D
@export var hurtbox : Area2D
@export var state_machine : StateMachine
@export var animation_player : AnimatedSprite2D

var target : Player

func _ready() -> void:
	animation_player.play("idle")

func _physics_process(delta: float) -> void:
	state_machine.update(delta)
	
