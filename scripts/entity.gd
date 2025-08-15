class_name Entity extends CharacterBody2D

@export var entity_stats : EntityStats
var current_hp : int = entity_stats.health

func take_damage(amount: float) -> void:
	current_hp -= amount

func take_knockback(force : float) -> void:
	pass
