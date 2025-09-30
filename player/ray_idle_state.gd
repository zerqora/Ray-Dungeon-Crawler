class_name RayIdleState extends State

func enter(data : Dictionary = {}) -> void:
	this_data = data
	this_data["animation"].play("idle")
