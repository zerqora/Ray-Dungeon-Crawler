class_name HealthManager extends Control

signal update_hp(amount : int)

var max_hp : int
var current_hp : int

func _ready() -> void:
	update_hp.connect(_on_hp_updated)
	
func _on_hp_updated(amount : int) -> void:
	pass
