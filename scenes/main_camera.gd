extends Camera2D

var sweeta_camera
var sweeta
var control_node
var item_list_node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sweeta = $"../Sweeta"
	var sweeta_camera_index
	sweeta_camera_index = sweeta.get_child_count()
	sweeta_camera = sweeta.get_child(sweeta_camera_index-1)
	set_custom_viewport(sweeta_camera.get_viewport())
	control_node = $Control
	item_list_node = $Control/ItemList


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
