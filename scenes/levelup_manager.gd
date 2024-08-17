extends Node

enum Game_States {
	ACTIVE,
	SLEEPING
}

@export var player_node: Node2D
var player
var state_to_emit: Game_States
signal state_change(state)

@export var control_node: Control
@export var item_list: ItemList



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = player_node.get_child(0) #spaghetti socorro
	player.leveled_up.connect(level_up_menu.bind())
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func level_up_menu(level: int):
	state_to_emit = Game_States.SLEEPING
	state_change.emit(state_to_emit)
	control_node.visible = true
	pass


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	state_to_emit = Game_States.ACTIVE
	state_change.emit(state_to_emit)
	control_node.visible = false
