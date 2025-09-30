class_name Entity extends CharacterBody2D

@export var entity_stats : EntityStats 
@export var hitbox : Area2D
@export var state_machine : StateMachine


var target : Player

func _physics_process(delta: float) -> void:
	state_machine.update(delta)
	
