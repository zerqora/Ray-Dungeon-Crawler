extends Node

var old_level : Node
var player : Player

func _ready() -> void:
	EventBus.door_entered.connect(_switch_to_new_level)
	old_level = $CurrentScene/Lobby
	player = load("res://player/player.tscn").instantiate()
	add_child(player)

## Instantiates the new level and teleports the player to the level's spawn point
func _switch_to_new_level(new_level_path : String) -> void:
	var new_level : Level = load("res://world/level_1.tscn").instantiate()
	$CurrentScene.add_child(new_level)
	old_level.queue_free()
	if new_level.spawn_point == null: 
		printerr("No spawnpoint exists") 
		return
	_teleport_player_to(new_level.spawn_point)
	old_level = new_level

## Teleports the player to the "Spawnpoint" node.
func _teleport_player_to(where: Marker2D) -> void:
	player.position = where.position
	
	
