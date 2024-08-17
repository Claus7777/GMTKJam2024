extends Sprite2D

enum Sword_States {
	ORIGINAL, CLONE
}

@export var state: Sword_States = Sword_States.ORIGINAL


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y = 0
	match state:
		Sword_States.ORIGINAL:
			global_rotation_degrees = 90
			if(scale > Vector2.ZERO):
				scale.x += Input.get_axis("grow","shrink");
				scale.y += Input.get_axis("grow","shrink")/10
			else: scale = Vector2(1,1)
			pass
		Sword_States.CLONE:
			pass
		
	pass
