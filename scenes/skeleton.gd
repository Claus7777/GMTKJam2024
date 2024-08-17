extends CharacterBody2D

var player
signal monster_died(exp_earned)
@export var health_points = 10;
@export var experience_on_kill = 5;
@export var enemy_speed = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_child(0).get_child(0)
	pass

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(player.position) * enemy_speed
	look_at(player.position)
	if position.distance_to(player.position) > 10:
		move_and_slide()

func take_damage(damage):
	health_points -= damage
	if health_points <= 0:
		monster_died.emit(experience_on_kill)
		queue_free()
