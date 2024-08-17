extends CharacterBody2D

enum Enemy_States {
	ACTIVE,
	SLEEPING
}

var enemy_state: Enemy_States = Enemy_States.ACTIVE
var player
signal monster_died(exp_earned)
@export var health_points = 10;
@export var experience_on_kill = 5;
@export var enemy_speed = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_child(0).get_child(0)
	pass

func _physics_process(_delta: float) -> void:
	match enemy_state:
		Enemy_States.ACTIVE:
			velocity = position.direction_to(player.global_position) * enemy_speed
			look_at(player.global_position)
			
			if position.distance_to(player.global_position) > 10:
				move_and_slide()
				
			if Input.is_action_just_pressed("grow"):
				enemy_state = Enemy_States.SLEEPING
		Enemy_States.SLEEPING:
			pass

func take_damage(damage):
	health_points -= damage
	if health_points <= 0:
		monster_died.emit(experience_on_kill)
		queue_free()
		
func change_state(state):
	enemy_state = state;
