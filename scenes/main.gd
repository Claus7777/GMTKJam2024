extends Node

@export var enemy_scene: PackedScene
@export var player_node: Node2D
var difficulty_timer = 0;
var mob_spawn_timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mob_spawn_timer = $MobSpawnTimer
	mob_spawn_timer.start()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mob_spawn_timer_timeout() -> void:
	difficulty_timer += 1
	var enemy = enemy_scene.instantiate()
	
	var enemy_spawn_location = $EnemySpawner/EnemySpawnLocation
	enemy_spawn_location.progress_ratio = randf()
	
	enemy.position = enemy_spawn_location.position
	var enemy_exp = enemy.experience_on_kill;$MobSpawnTimer
	enemy.monster_died.connect(player_node.get_child(0).earn_exp.bind())
	add_child(enemy)
	
	if difficulty_timer > 5:
		mob_spawn_timer.wait_time -= 0.01
