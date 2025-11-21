class_name Attack extends Node2D

@export var stats : AttackStats
@export var cooldown : Timer
@export var hitbox : Area2D
@export var animation : AnimatedSprite2D
# TODO: add animation export
func _ready() -> void:
	animation.animation_finished.connect(despawn)
	visible = true

func deal_damage(entity : Entity) -> void:
	print("Dealt damage")
	var damage : int = stats.damage
	var true_damage : bool = stats.true_damage
	entity.decrement(damage)

func spawn(where : Vector2) -> void:
	# if on cooldown
	if not cooldown.is_stopped(): return
	# print("spawned at", global_position)
	_go_on_cooldown()
	global_position = where

func despawn() -> void:
	queue_free()

func flip_animation(flip : bool) -> void:
	animation.flip_h = flip

func _go_on_cooldown() -> void:
	if !cooldown.is_stopped(): return
	# print("on cooldown")
	cooldown.start()

func _go_off_cooldown() -> void:
	# print("off cooldown")
	cooldown.stop()
	
func on_hitbox_triggered(_area: Area2D) -> void:
	print("hit entity")

func play_animation(flipped : bool) -> void:
	pass
