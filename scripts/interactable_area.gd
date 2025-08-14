class_name InteractArea extends Area2D

signal entered_area
signal exited_area

@onready var interact_label : Label = $"Press E To Interact"

func _ready() -> void:
	entered_area.connect(show_interactable)
	exited_area.connect(hide_interactable)
	interact_label.hide()
	
	
#TODO: make this return an entity
func _on_entered_area(area: Area2D) -> void:
	entered_area.emit()

func _on_exited_area(area: Area2D) -> void:
	exited_area.emit()
	
func show_interactable() -> void:
	interact_label.show()

func hide_interactable() -> void:
	interact_label.hide()
	
	
