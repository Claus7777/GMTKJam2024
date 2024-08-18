extends TileMapLayer

@export var health_points = 10
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func take_damage(damage):
	health_points -= damage
	if health_points <= 0:
		queue_free()
	
