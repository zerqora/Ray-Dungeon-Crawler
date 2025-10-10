class_name DashState extends State

var speed : int = 0
var upward_force : float = 0
## Timer that reaches the dash duration.
var timer : float = 0
## Timer that is 
var force_timer : float = 0
var applied_force_duration : float = .05
var dash_duration : float = .5
var acceleration : float = 500
var knockback : int = 6000
var friction = .9
var collided : bool = false

@export var hitbox : Area2D

func enter(data : Dictionary = {}) -> void:
	this_data = data
	speed = this_data["stats"].speed
	#print("dashing")
	
	# What the freak is happening
func update(owner, delta: float) -> void:
	timer += delta
	# Connect the hitbox signal so that on collision during this time, Ray is affected by an upward force.
	if !hitbox.area_entered.is_connected(on_collision):
		hitbox.area_entered.connect(on_collision)
	# Edit the velocities when Ray should be in the air after collision
	if collided:
		# Timer runs when the collision has occured
		force_timer += delta
		owner.velocity.y = upward_force * delta
		owner.velocity.x += knockback * (-1 if this_data["animation"].flip_h == true else 1) * delta
	owner.move_and_slide()
	
	# When the upwards force duration has been met, exit to the falling state
	if force_timer > applied_force_duration:
		finished.emit(neighboring_nodes[0], this_data)
		return
	# Dash ran out of time, exit to the falling state for code safety. Falling state will emit to the idle state immediately if not in air
	if timer > dash_duration: 
		finished.emit(neighboring_nodes[0], this_data)

func on_collision(area : Area2D) -> void:
	# apply a force upwards, then emit the finished signal to falling.
	# the player data should hold a key to a streak value, which when it increases, it divides the upward force.
	# streak should decrease at some point (or reset)
	if area == SightLine: return
	upward_force = -14000
	collided = true
	print("collided while dashing.")

# Reset timers and forces and disconnect hitbox from the dashing logic
func exit(next_state : State) -> void:
	hitbox.area_entered.disconnect(on_collision)
	collided = false
	timer = 0
	force_timer = 0
	upward_force = 0
