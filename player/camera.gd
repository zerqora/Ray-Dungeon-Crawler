class_name PlayerCamera extends Camera2D

var default_zoom : Vector2 = zoom
var player : Player

signal start_following_player(player)

func _ready() -> void:
	start_following_player.connect(initialize_player)

func initialize_player(plyr) -> void:
	player = plyr
	print("Initialized")

func zoom_out_for_seconds(new_zoom : Vector2, duration : float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", new_zoom, duration)

func zoom_to_default(duration : float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", default_zoom, duration)

func follow_player() -> void:
	if player == null: 
		#print("Player not found")
		return
	global_position = player.global_position
	tween_to_player()

func tween_to_player():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position", player.global_position, .5)

func _process(delta: float) -> void:
	follow_player()
