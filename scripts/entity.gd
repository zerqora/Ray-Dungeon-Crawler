class_name Entity extends CharacterBody2D

@export var entity_stats : EntityStats
@export var hitbox : Area2D
@export var damage : Area2D

var speed = entity_stats.speed
var current_hp : int = entity_stats.health

func take_damage(amount: float) -> void:
	current_hp -= amount

func take_knockback(force : float) -> void:
	pass

func _deal_damage(who: Player) -> void:
	pass
	
