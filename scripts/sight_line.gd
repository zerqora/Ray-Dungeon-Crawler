class_name SightLine extends RayCast2D

signal found_player(player)

func _process(delta: float) -> void:
	if is_colliding():
		found_player.emit(get_collider())
	
