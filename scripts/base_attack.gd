class_name Attack extends Node2D

@export var stats : AttackStats
@export var cooldown : Timer
@export var hitbox : Area2D
# TODO: add animation export
	
func _deal_damage(entity : Entity) -> void:
	print("Dealt damage")
	var damage : int = stats.damage
	var true_damage : bool = stats.true_damage
	entity.lose_health(damage, true_damage)

func _spawn() -> void:
	if not visible or not cooldown.is_stopped(): return
	print("spawned at", global_position)

func _go_on_cooldown() -> void:
	hide()
	cooldown.start()

func _go_off_cooldown() -> void:
	cooldown.stop()
