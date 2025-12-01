class_name FlameFist extends Attack

func spawn(where) -> void:
	super(where)
	animation.play("default")

func on_hitbox_triggered(hitbox : Area2D) -> void:
	var entity : Entity = hitbox.owner
	entity.damaged.emit(self.hitbox)
	
	print("Hit entity with a flame fist.")
		
