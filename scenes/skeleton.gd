extends CharacterBody2D

enum Enemy_States {
	ACTIVE,
	SLEEPING,
	TAKING_DAMAGE
}

var enemy_state: Enemy_States = Enemy_States.ACTIVE
var sent_state: Enemy_States
var player
var audio_player
var should_die: bool = false
var hitbox
var sprite


signal monster_died(exp_earned)
signal player_hit(damage)

@export var health_points = 10;
@export var experience_on_kill = 5;
@export var enemy_speed = 100;
@export var hitstun_counter = 0;
@export var hitstun_limit = 4;
@export var damage = 2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_child(0).get_child(0)
	hitbox = $CollisionShape2D
	audio_player = $AudioStreamPlayer2D
	sprite = $AnimatedSprite2D
	sent_state = enemy_state

func _physics_process(delta: float) -> void:
	match enemy_state:
		Enemy_States.ACTIVE:
			velocity = position.direction_to(player.global_position) * enemy_speed
			look_at(player.global_position)
			
			if position.distance_to(player.global_position) > 10:
				var collider = move_and_collide(velocity * delta)
				sprite.play("walk")
				if collider:
					if collider.get_collider().has_method("player_take_damage"):
						player_hit.emit(damage)
			
		Enemy_States.SLEEPING:
			sprite.play("idle")
			pass
		Enemy_States.TAKING_DAMAGE:
			hitstun_counter+=1
			if hitstun_counter < hitstun_limit:
				sprite.sprite_flash()
				velocity = position.direction_to(player.global_position) * enemy_speed * -1
				look_at(player.global_position)
				move_and_slide()
				
			else: enemy_state = sent_state

func take_damage(damage):
	audio_player.pitch_scale = randf_range(0.5, 1.5)
	audio_player.play()
	health_points -= damage
	if health_points <= 0:
		monster_died.emit(experience_on_kill)
		visible = false
		hitbox.queue_free()
		should_die = true
	else:
		enemy_state = Enemy_States.TAKING_DAMAGE
		
func change_state(state):
	enemy_state = state;
	sent_state = state;


func _on_audio_stream_player_2d_finished() -> void:
	if should_die:
		queue_free()
	pass # Replace with function body.
	
