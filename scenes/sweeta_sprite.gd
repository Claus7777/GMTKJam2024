extends AnimatedSprite2D

func sprite_flash() -> void:
	var tween: Tween = get_tree().create_tween()

	tween.tween_property(self, "modulate", Color.DARK_RED, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	tween.tween_property(self, "modulate", Color.DARK_RED, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
