class_name InteractArea extends Area2D

@onready var interact_label : Label = $"Press E To Interact"

signal entered_area(area: Area2D)
signal exited_area(area: Area2D)

var in_area : bool = false

func _ready() -> void:
	area_entered.connect(_on_entered_area)
	area_exited.connect(_on_exited_area)
	interact_label.hide()
	
	
#TODO: make this return an entity
func _on_entered_area(_area: Area2D) -> void:
	in_area = true
	show_interactable()
	entered_area.emit()

func _on_exited_area(_area: Area2D) -> void:
	in_area = false
	hide_interactable()
	exited_area.emit()

func show_interactable() -> void:
	interact_label.show()

func hide_interactable() -> void:
	interact_label.hide()
	
	
