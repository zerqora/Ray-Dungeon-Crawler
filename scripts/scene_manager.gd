class_name DungeonManager extends Node

var old_level : Node
var player : Player
var camera : PlayerCamera

func _ready() -> void:
	EventBus.door_entered.connect(_switch_to_new_level)
	old_level = $CurrentScene/Lobby
	player = load("res://player/player.tscn").instantiate()
	#camera = load("res://player/camera.tscn").instantiate()
	#add_child(camera)
	add_child(player)
	#camera.start_following_player.emit(player)
	Camera.start_following_player.emit(player)
	print("Added player..")

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
	
	
