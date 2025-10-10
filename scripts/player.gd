class_name Player extends CharacterBody2D
# Eventually create a state machine to control what happens to inputs. Getting the basics down and changing it later.

@onready var attack_slots = {
	"FlameFist" = $FlameFist
}
@onready var attack_cooldowns = {
	"FlameFist" = $FlameFist/Cooldown,
	"Dash" = null
}

@onready var animation = $Sprite2D
@export var player_stats : PlayerStats
var speed: int = 5000
var gravity: int = 5000
var dashing : bool = false

func _ready() -> void:
	animation.play("idle")
	var values : Array = attack_slots.values()
	for value : Attack in values:
		value.hide()

	
#func _attempt_to_spawn_attack(attack: String) -> void:
	#var attack_selected : Attack = attack_slots[attack]
	#if attack_selected.visible: return
	#attack_selected.global_position = Vector2(global_position.x + (direction * 10), global_position.y - 20)
	#attack_selected.spawn()
