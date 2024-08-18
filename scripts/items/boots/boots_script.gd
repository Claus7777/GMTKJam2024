extends Node

@export var player: Node2D

func item_effect() -> void:
	if player.SPEED < player.SPEED_CAP:
		player.SPEED += 50
	print(player.name, "Speed Increased")
