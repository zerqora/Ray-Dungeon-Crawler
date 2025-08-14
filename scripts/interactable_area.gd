class_name InteractArea extends Area2D

signal entered_area()
signal exited_area()

#TODO: make this return an entity
func on_entered_area() -> void:
	entered_area.emit()

func on_exited_area() -> void:
	exited_area.emit()
	
	
