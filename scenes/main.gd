extends Node

enum Game_States {
	ACTIVE,
	SLEEPING,
	CREDITS,
	TITLE
}

var game_state: Game_States = Game_States.ACTIVE
var prev_state: Game_States
signal state_change(state)

@export var enemy_scene: PackedScene
@export var player_node: Node2D
@export var levelup_manager: Node
var difficulty_timer = 0;
var mob_spawn_timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mob_spawn_timer = $MobSpawnTimer
	mob_spawn_timer.start()
	
	levelup_manager.state_change.connect(change_game_state.bind())
	state_change.connect(player_node.get_child(0).change_state.bind())


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match game_state:
			Game_States.ACTIVE:
				if mob_spawn_timer.is_paused():
					mob_spawn_timer.paused = false
				pass
			Game_States.SLEEPING:
				mob_spawn_timer.paused = true
	pass
func _on_mob_spawn_timer_timeout() -> void:
	difficulty_timer += 1
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = $Sweeta/CharacterBody2D/Camera2D/EnemySpawner/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	var enemy_exp = enemy.experience_on_kill;
	enemy.monster_died.connect(player_node.get_child(0).earn_exp.bind())
	state_change.connect(enemy.change_state.bind())
	enemy.player_hit.connect(player_node.get_child(0).player_take_damage.bind())
	var shiny_skeleton_flag
	shiny_skeleton_flag = randi_range(0, 20)
	if(shiny_skeleton_flag == 20):
		enemy.scale*=2
		enemy.health_points = 100
		enemy.is_dragon = true
	add_child(enemy)
	
	if difficulty_timer > 5:
		difficulty_timer = 0
		if mob_spawn_timer.wait_time > 0: mob_spawn_timer.wait_time -= 0.01

func change_game_state(new_state):
	prev_state = game_state;
	game_state = new_state;
	state_change.emit(game_state)
