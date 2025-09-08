class_name InteractObject extends Node2D

@export var interact_area : InteractArea

func _ready() -> void:
	EventBus.on_interaction_button_pressed.connect(_handle_interaction)
	
func _handle_interaction() -> void:
	pass
	
