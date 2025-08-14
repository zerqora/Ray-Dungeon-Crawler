extends CharacterBody2D

enum DIRECTION {
	NONE = 0,
	RIGHT = 1,
	LEFT = -1
}
var speed = 5000
var direction = DIRECTION.NONE
var gravity = 5000

func _physics_process(delta: float) -> void:
	_handle_input()
	velocity.x = direction * speed * delta
	if not is_on_floor():
		velocity.y = gravity * delta
	move_and_slide()

func _handle_input() -> void:
	if Input.is_action_just_pressed("LEFT"):
		direction = DIRECTION.LEFT
	if Input.is_action_just_pressed("RIGHT"):
		direction = DIRECTION.RIGHT
	if Input.is_action_just_released("LEFT") or Input.is_action_just_released("RIGHT"):
		direction = DIRECTION.NONE
		
	
