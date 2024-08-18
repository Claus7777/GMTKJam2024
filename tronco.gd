extends TileMapLayer

@export var health_points = 10
var particle_emitter
var audio_player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particle_emitter = $GPUParticles2D
	audio_player = $AudioStreamPlayer2D
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func take_damage(damage):
	health_points -= damage
	if health_points <= 0:
		queue_free()
	else: 
		particle_emitter.emitting = true
		audio_player.play()
