class_name Attack extends Node2D

@export var stats : AttackStats
@export var cooldown : Timer
@export var hitbox : Area2D
# TODO: add animation export
func _ready() -> void:
	hitbox.area_entered.connect(on_hitbox_triggered)
	hitbox.monitorable = false
	hitbox.monitoring = false

func deal_damage(entity : Entity) -> void:
	print("Dealt damage")
	var damage : int = stats.damage
	var true_damage : bool = stats.true_damage
	entity.lose_health(damage, true_damage)

func spawn() -> void:
	# if on cooldown
	if not cooldown.is_stopped(): return
	visible = true
	# print("spawned at", global_position)
	hitbox.monitorable = true
	hitbox.monitoring = true
	_go_on_cooldown()

func despawn() -> void:
	if visible:
		hide()
		hitbox.monitorable = false
		hitbox.monitoring = false

func _go_on_cooldown() -> void:
	if !cooldown.is_stopped(): return
	# print("on cooldown")
	cooldown.start()

func _go_off_cooldown() -> void:
	# print("off cooldown")
	cooldown.stop()
	
func on_hitbox_triggered(_area: Area2D) -> void:
	print("hit entity")
