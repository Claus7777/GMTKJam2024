extends CharacterBody2D

var player
@export var enemy_speed = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent().get_child(0)
	pass

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(player.position) * enemy_speed
	look_at(player.position)
	if position.distance_to(player.position) > 10:
		move_and_slide()
