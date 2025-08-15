extends Node

@onready var old_level  = $CurrentScene/Lobby

func _ready() -> void:
	EventBus.door_entered.connect(_switch_to_new_level)
	
func _switch_to_new_level() -> void:
	var new_level = load("res://world/level_1.tscn").instantiate()
	$CurrentScene.add_child(new_level)
	old_level.queue_free()
	old_level = new_level
	
	
