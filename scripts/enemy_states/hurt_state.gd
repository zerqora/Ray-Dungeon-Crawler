class_name HurtState extends State

var timer : float = 0
var duration : float = .25

func enter(data : Dictionary = {}) -> void:
	this_data = data
	var tween = get_tree().create_tween()
	tween.tween_property(owner, "modulate", Color.RED, .1)
	tween.tween_property(owner, "modulate", Color.WHITE, .1)

func update(owner, delta : float) -> void:
	timer += delta
	if timer > duration:
		finished.emit(neighboring_nodes[0], this_data)
		#print("finished the Hurt State")

func exit(_next_state : State) -> void:
	timer = 0
