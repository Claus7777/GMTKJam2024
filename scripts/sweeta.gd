extends CharacterBody2D

enum Character_States {
	ACTIVE,
	SLEEPING, #State usado pra main menu e pause
	SWORDLESS, #Usado na introdução do jogo
}

var character_state: Character_States = Character_States.ACTIVE
signal leveled_up(level)

@export var SPEED = 300.0
@export var SPEED_CAP = 500.0
@export var hitbox_scene: PackedScene
@export var hitbox_size_multiplier:float = 2
@export var experience = 0.0
@export var protagonist_level = 1
@export var health_points = 50

@export var level_dictionary = {
	1 : 0, ##Legenda: LEVEL : EXPERIENCIA_NECESSÁRIA
	2 : 10,
	3 : 20,
	4 : 50,
	5 : 100,
	6 : 120,
	7 : 130,
	8 : 140,
	9 : 150,
	10 : 160
}

@export var sounds: Array[AudioStream]

var isAttacking:bool = false;
var isInvincible:bool = false;
var is_attacking_timer
var attack_cooldown_timer
var hand_node
var hand_area_2d
var new_hand_node
var sword_node
var screen_size
var hitbox
var audio_player
var invincibility_timer
var sprite

func _ready() -> void:
	screen_size = get_viewport_rect().size
	is_attacking_timer = $isAttackingTimer
	attack_cooldown_timer = $AttackCooldown
	hand_node = $HandBody2D/Hand
	hand_area_2d = $HandBody2D
	sword_node = hand_node.get_child(0)
	audio_player = $AudioStreamPlayer2D
	invincibility_timer = $InvincibilityTimer
	sprite = $AnimatedSprite2D
	pass

func _process(delta: float) -> void:
	var next_level = protagonist_level + 1
	if level_dictionary.has(next_level):
		if experience >= level_dictionary[next_level]:
			levelup()

func _physics_process(delta: float) -> void:
	match character_state:
		Character_States.SWORDLESS:
			if hand_node.visible:
				hand_node.visible = false
			calculate_movement(delta)
			
		Character_States.ACTIVE:
			calculate_movement(delta)
			
			if Input.is_action_pressed("attack") and not isAttacking:
				sweeta_attack()
			
			if velocity != Vector2.ZERO:
				sprite.play("walk")
			else: sprite.play("idle")
			
		Character_States.SLEEPING:
			sprite.pause()
			pass


func calculate_movement(delta):
			var direction_x := Input.get_axis("move_left", "move_right")
			var direction_y := Input.get_axis("move_up", "move_down")
			
			if direction_x or direction_y:
				velocity.x = direction_x * SPEED
				velocity.y = direction_y * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.y = move_toward(velocity.y, 0, SPEED)
				
			var collision_info = move_and_collide(velocity * delta)
			if collision_info:
				var collision_point = collision_info.get_position()
				print(collision_point)

func sweeta_attack():
	isAttacking = true;
	is_attacking_timer.start()
	attack_cooldown_timer.start()
	
	new_hand_node = hand_node.duplicate()
	sword_node.visible = false
	
	hitbox = hitbox_scene.instantiate()
	hitbox.global_position += Vector2(0,-150 * hitbox_size_multiplier)
	hitbox.scale *= hitbox_size_multiplier
	hand_node.add_child(hitbox)
	if audio_player.stream != sounds[0]:
		audio_player.stream = sounds[0]
	audio_player.play()

func _on_attack_cooldown_timeout() -> void:
	isAttacking = false
	pass

func earn_exp(exp_to_earn):
	experience += exp_to_earn;
	var tiny_sword_grow:float = exp_to_earn * 0.0001
	hitbox_size_multiplier *= 1+tiny_sword_grow;
	sword_node.scale.y *= 1+tiny_sword_grow
	sword_node.scale.x *= 1+tiny_sword_grow

func levelup():
	protagonist_level += 1
	audio_player.pitch_scale -= 0.1
	hitbox_size_multiplier *= 1.1;
	sword_node.scale.y *= 1.5
	sword_node.scale.x *= 1.25
	if protagonist_level < 6: sword_node.offset.y += 1 * hitbox_size_multiplier 
	elif protagonist_level < 7: sword_node.offset.y -= 1 * hitbox_size_multiplier 
	leveled_up.emit(protagonist_level)
	print("Level up! Level ", protagonist_level)

func change_state(state):
	character_state = state;

func _on_attack_timeout() -> void:
	hitbox.queue_free()
	if sword_node.visible == false:
		sword_node.visible = true

func player_take_damage(damage_taken):
	if not isInvincible:
		invincibility_timer.start()
		isInvincible = true
		sprite.sprite_flash()
		health_points -= damage_taken
		audio_player.stream = sounds[1]
		audio_player.play()
	
	
func _on_invincibility_timer_timeout() -> void:
	isInvincible = false
