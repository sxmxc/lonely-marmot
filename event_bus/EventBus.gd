extends Node2D

var buses: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Events:
			buses[child.name] = child as Events
	Logger.log_message("EventBus::ready")
	pass # Replace with function body.

