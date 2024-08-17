extends CharacterBody2D

enum Character_States {
	ACTIVE,
	SLEEPING, #State usado pra main menu e pause
	SWORDLESS, #Usado na introdução do jogo
}

var character_state: Character_States = Character_States.ACTIVE
signal leveled_up(level)

@export var SPEED = 300.0
@export var hitbox_scene: PackedScene
var hitbox
@export var hitbox_size_multiplier:float = 2
@export var experience = 0.0
@export var protagonist_level = 1

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

var isAttacking:bool = false;
var attack_cooldown_timer
var hand_node
var hand_area_2d
var new_hand_node
var sword_node
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	attack_cooldown_timer = $AttackCooldown
	hand_node = $HandBody2D/Hand
	hand_area_2d = $HandBody2D
	sword_node = hand_node.get_child(0)
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
			calculate_movement()
			
		Character_States.ACTIVE:
			calculate_movement()
			
			if Input.is_action_just_pressed("attack") and not isAttacking:
				sweeta_attack()
			
		Character_States.SLEEPING:
			pass


func calculate_movement():
			var direction_x := Input.get_axis("move_left", "move_right")
			var direction_y := Input.get_axis("move_up", "move_down")
			
			if direction_x or direction_y:
				velocity.x = direction_x * SPEED
				velocity.y = direction_y * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.y = move_toward(velocity.y, 0, SPEED)
				
			move_and_slide()

func sweeta_attack():
	isAttacking = true;
	attack_cooldown_timer.start()
	
	new_hand_node = hand_node.duplicate()
	sword_node.visible = false
	
	hitbox = hitbox_scene.instantiate()
	hitbox.global_position += Vector2(0,-150 * hitbox_size_multiplier)
	hitbox.scale *= hitbox_size_multiplier
	hand_node.add_child(hitbox)
	pass

func _on_attack_cooldown_timeout() -> void:
	isAttacking = false;
	hitbox.queue_free()
	if sword_node.visible == false:
		sword_node.visible = true

func earn_exp(exp_to_earn):
	experience += exp_to_earn;
	var tiny_sword_grow:float = exp_to_earn * 0.0001
	hitbox_size_multiplier *= 1+tiny_sword_grow;
	sword_node.scale.y *= 1+tiny_sword_grow
	sword_node.scale.x *= 1+tiny_sword_grow
	print(experience)

func levelup():
	protagonist_level += 1
	
	hitbox_size_multiplier *= 1.1;
	sword_node.scale.y *= 1.5
	sword_node.scale.x *= 1.25
	if protagonist_level < 6: sword_node.offset.y += 1 * hitbox_size_multiplier 
	elif protagonist_level < 7: sword_node.offset.y -= 1 * hitbox_size_multiplier 
	leveled_up.emit(protagonist_level)
	print("Level up! Level ", protagonist_level)

func change_state(state):
	character_state = state;
