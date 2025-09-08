class_name EnemySpawns extends Node2D

## All the spawns under the enemy spawn node that this script is attached to.
var spawns : Array[Marker2D]

func _ready() -> void:
	for child in get_children():
		spawns.append(child)
	print("Enemy spawns: ", spawns)
