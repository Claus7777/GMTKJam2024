extends StaticBody2D

enum Game_States {
	ACTIVE,
	SLEEPING
}

var game_state: Game_States = Game_States.ACTIVE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	game_state = get_tree().get_root().get_child(0).game_state
	match game_state:
		Game_States.ACTIVE:
			look_at(get_global_mouse_position())
		Game_States.SLEEPING:
			pass
	
