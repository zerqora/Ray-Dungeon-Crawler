class_name HurtState extends State

var timer : float = 0
var duration : float = .5

func enter(data : Dictionary = {}) -> void:
	this_data = data

func update(owner, delta : float) -> void:
	timer += delta
	if timer > duration:
		finished.emit(neighboring_nodes[0], this_data)
		#print("finished the Hurt State")

func exit(_next_state : State) -> void:
	timer = 0
