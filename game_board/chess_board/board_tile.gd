extends Control
class_name BoardTile

#var board_position: Vector2i

var current_unit: Unit
var tile_size: Vector2
var tile_data: Dictionary

@onready var tile_display = get_node("TileDisplay")
@onready var location_label = get_node("TileDisplay/LocationLabel")
@onready var rankfile_label = get_node("TileDisplay/RankFileLabel")

var highlighted = false

# Called when the node enters the scene tree for the first time.
func _ready():
	size = tile_size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if highlighted:
		tile_display.visible = true
	else:
		tile_display.visible = false
	pass

func remove_unit():
	current_unit = null
	pass

func add_unit(unit):
	current_unit = unit


func _on_mouse_entered():
	highlighted = true
	location_label.text = str(tile_data["board_position"])
	rankfile_label.text = str(tile_data["file"]) + tile_data["rank"]
	pass # Replace with function body.


func _on_mouse_exited():
	highlighted = false
	pass # Replace with function body.
