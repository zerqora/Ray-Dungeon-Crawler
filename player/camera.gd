class_name PlayerCamera extends Camera2D

var default_zoom : Vector2 = zoom

func zoom_out_for_seconds(new_zoom : Vector2, duration : float):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", new_zoom, duration)

func zoom_to_default(duration : float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "zoom", default_zoom, duration)
