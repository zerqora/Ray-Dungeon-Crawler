class_name OxygenHUD extends Control

var oxygen_amount : float = 100
var max_capacity : float = 100

func _lose_oxygen(amount : float) -> void:
	if oxygen_amount <= 0:
		# print("ran out of oxygen")
		return
	oxygen_amount -= amount
	

var current_seconds : float = 0
var seconds_to_update : int = 1
func _process(delta: float) -> void:
	if current_seconds > seconds_to_update:
		current_seconds = 0
		_lose_oxygen(10)
		_update_progress_bar()
	current_seconds += delta

func _update_progress_bar() -> void:
	$%TextureProgressBar.value = oxygen_amount / max_capacity * 100
