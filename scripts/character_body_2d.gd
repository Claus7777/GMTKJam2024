extends CharacterBody2D

@export var SPEED = 300.0
@export var hitbox_scene: PackedScene
var hitbox
@export var hitbox_size_multiplier:float = 2
@export var experience = 0.0

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
	pass
		

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x := Input.get_axis("move_left", "move_right")
	var direction_y := Input.get_axis("move_up", "move_down")
	
	if direction_x or direction_y:
		velocity.x = direction_x * SPEED
		velocity.y = direction_y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	if Input.is_action_just_pressed("attack") and not isAttacking:
		sweeta_attack()
	move_and_slide()
	position = position.clamp(Vector2.ZERO, screen_size)

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
	print(experience)
