extends Area2D

@export var damage:int = 5;
var sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $AnimatedSprite2D
	sprite.play("slash")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	body.take_damage(damage)
	pass # Replace with function body.
