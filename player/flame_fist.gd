class_name FlameFist extends Attack

@onready var lifetime = $Lifetime

func spawn() -> void:
	super()
	lifetime.start(.2)
	print("lifetime started")
	
func _on_lifetime_timeout() -> void:
	print("lifetime ended")
	_go_on_cooldown()
	despawn()
