extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func sprite_flash() -> void:
	var tween: Tween = get_tree().create_tween()

	tween.tween_property(self, "modulate", Color.YELLOW, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	tween.tween_property(self, "modulate", Color.YELLOW, 0.05)
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
