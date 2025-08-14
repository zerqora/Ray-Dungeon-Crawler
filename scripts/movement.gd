extends CharacterBody2D

enum DIRECTION {
	NONE = 0,
	RIGHT = 1,
	LEFT = -1
}
var speed: int = 5000
var direction: int = DIRECTION.NONE
var gravity: int = 5000

@onready var animation = $Sprite2D

func _ready() -> void:
	animation.play("idle")

func _physics_process(delta: float) -> void:
	_handle_input()
	velocity.x = direction * speed * delta
	if not is_on_floor():
		velocity.y = gravity * delta
	move_and_slide()

# TODO: Implement State Machine
func _handle_input() -> void:
	var stopped_moving: bool = Input.is_action_just_released("LEFT") or Input.is_action_just_released("RIGHT")
	var cancelled_out_direction : bool = Input.is_action_pressed("LEFT") and Input.is_action_pressed("RIGHT")
	
	if stopped_moving or cancelled_out_direction:
		direction = DIRECTION.NONE
	elif Input.is_action_pressed("LEFT"):
		direction = DIRECTION.LEFT
		animation.flip_h = false
	elif Input.is_action_pressed("RIGHT"):
		direction = DIRECTION.RIGHT
		animation.flip_h = true
	
		
	
