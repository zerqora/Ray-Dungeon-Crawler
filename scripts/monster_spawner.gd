class_name EnemyManager extends Node

var enemies : Dictionary = {
	"Miner" = "res://enemies/base_entity.tscn"
}

func _ready() -> void:
	EventBus.level_ready.connect(_determine_enemies_by_level)
	
func _spawn_enemy(where : Vector2, enemy : NodePath) -> void:
	var entity : Entity = load(enemy).instantiate()
	entity.global_position = where
	add_child(entity)
	print("Added entity ", entity)
	
func _determine_enemies_by_level(level : Level) -> void:
	var spawn_points : Array[Marker2D] = level.enemy_spawn_points.spawns
	# print("Here is the current level's enemy spawn points: ", spawn_points)
	for spawns in spawn_points: 
		_spawn_enemy(spawns.global_position, enemies["Miner"])
