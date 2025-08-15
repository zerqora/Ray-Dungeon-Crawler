class_name Attack extends Node2D

func deal_damage(entity : Entity) -> void:
	entity.lose_health()


	


func _spawn() -> void:
	print("spawned")
