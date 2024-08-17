extends Node

enum Game_States {
	ACTIVE,
	SLEEPING
}

@export var player_node: Node2D
var player
var state_to_emit: Game_States
signal state_change(state)
var options = [0,1]

@export var control_node: Control
@export var item_list: ItemList

@export var upgrade_itens_array = Array([Item])

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = player_node.get_child(0) #spaghetti socorro
	player.leveled_up.connect(level_up_menu.bind())
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func level_up_menu(level: int):
	var random_item_chooser
	state_to_emit = Game_States.SLEEPING
	state_change.emit(state_to_emit)
	random_item_chooser = randi_range(0, upgrade_itens_array.size()-1)
	item_list.set_item_icon(0, upgrade_itens_array[random_item_chooser].icon)
	item_list.set_item_text(0, upgrade_itens_array[random_item_chooser].name)
	options[0] = random_item_chooser
	
	random_item_chooser = randi_range(0, upgrade_itens_array.size()-1)
	item_list.set_item_icon(1, upgrade_itens_array[random_item_chooser].icon)
	item_list.set_item_text(1, "Bluejeeta")
	options[1] = random_item_chooser
	control_node.visible = true
	pass


func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	state_to_emit = Game_States.ACTIVE
	var item_script = upgrade_itens_array[options[index]].item_script.new()
	item_script.player = player_node.get_child(0)
	item_script.item_effect()
	state_change.emit(state_to_emit)
	control_node.visible = false
