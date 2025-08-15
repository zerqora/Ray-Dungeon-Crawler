class_name Door extends InteractObject

func _handle_interaction() -> void:
	EventBus.door_entered.emit()
