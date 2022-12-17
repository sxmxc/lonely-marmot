extends Node2D
class_name Unit

@export var unit_data : UnitData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.


func get_type() -> GlobConsts.UNIT_TYPE:
	return unit_data.type

func get_name():
	pass
