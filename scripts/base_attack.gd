class_name Attack extends Node2D

@export var stats : AttackStats
@export var cooldown : Timer
@export var hitbox : Area2D
# TODO: add animation export
func _ready() -> void:
	hitbox.area_entered.connect(on_hitbox_triggered)

func deal_damage(entity : Entity) -> void:
	print("Dealt damage")
	var damage : int = stats.damage
	var true_damage : bool = stats.true_damage
	entity.lose_health(damage, true_damage)

func spawn() -> void:
	if not visible or not cooldown.is_stopped(): return
	print("spawned at", global_position)

func despawn() -> void:
	if visible:
		hide()

func _go_on_cooldown() -> void:
	cooldown.start()

func _go_off_cooldown() -> void:
	cooldown.stop()
	
func on_hitbox_triggered(area: Area2D) -> void:
	if area.get_parent() is Entity:
		deal_damage(area.get_parent())
