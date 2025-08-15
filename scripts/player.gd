extends CharacterBody2D

# Eventually create a state machine to control what happens to inputs. Getting the basics down and changing it later.
enum DIRECTION {
	NONE = 0,
	RIGHT = 1,
	LEFT = -1
}

var attack_slots = {
	"Flame_Fist" = load("res://player/flame_fist.tscn"),
}
var speed: int = 5000
var direction: int = DIRECTION.NONE
var gravity: int = 5000


@onready var attack_cooldown_timer = $AttackCooldown
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
	# Feels more predictable to the player if pressing left AND right cancelled out movement.
	var cancelled_out_direction : bool = Input.is_action_pressed("LEFT") and Input.is_action_pressed("RIGHT")

	if stopped_moving or cancelled_out_direction:
		direction = DIRECTION.NONE
	elif Input.is_action_pressed("LEFT"):
		direction = DIRECTION.LEFT
		animation.flip_h = false
	elif Input.is_action_pressed("RIGHT"):
		direction = DIRECTION.RIGHT
		animation.flip_h = true
	if Input.is_action_just_pressed("INTERACT"):
		EventBus.on_interaction_button_pressed.emit()
	if Input.is_action_just_pressed("ATTACK"):
		_attempt_to_spawn_attack()
	
func _attempt_to_spawn_attack() -> void:
	if not attack_cooldown_timer.is_stopped(): return
	
		
	
