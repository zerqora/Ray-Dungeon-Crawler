class_name OxygenHUD extends Control

var oxygen_amount : float = 100
var max_capacity : float = 100

func _lose_oxygen(amount : float) -> void:
	if oxygen_amount <= 0:
		# print("ran out of oxygen")
		return
	oxygen_amount -= amount
	

var current_seconds : float = 0
var seconds_to_update : int = .75
func _process(delta: float) -> void:
	if current_seconds > seconds_to_update:
		current_seconds = 0
		_lose_oxygen(.1)
	current_seconds += delta
	_update_progress_bar()

func _update_progress_bar() -> void:
	$%OxygenLeft.value = oxygen_amount / max_capacity * 100
