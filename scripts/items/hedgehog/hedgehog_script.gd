extends Node

@export var player: Node2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func item_effect() -> void:
	if player.attack_cooldown_timer.wait_time - 0.2 > 0:
		player.attack_cooldown_timer.wait_time -= 0.2
	print(player.name, "Attack Speed Increased")
