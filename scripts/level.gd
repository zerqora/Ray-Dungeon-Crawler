class_name Level extends Node2D

@export var spawn_point : Marker2D
## A node with all the enemy spawn points to spawn at.
@export var enemy_spawn_points : EnemySpawns
	
## When the level enters the main tree, updates the path to match correctly.
func _enter_tree() -> void:
	await self.ready
	EventBus.level_ready.emit(self)
	
