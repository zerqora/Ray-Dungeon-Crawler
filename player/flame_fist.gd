class_name FlameFist extends Attack

@onready var lifetime = $Lifetime

func spawn() -> void:
	super()
	lifetime.start(.2)
	
func _on_lifetime_timeout() -> void:
	_go_on_cooldown()
	despawn()
