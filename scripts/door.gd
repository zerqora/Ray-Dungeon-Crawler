class_name Door extends InteractObject

func _handle_interaction() -> void:
	if not interact_area.in_area: return
	EventBus.door_entered.emit("res://world/level_1.tscn")
	print("Door entered")
