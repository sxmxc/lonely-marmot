extends Node2D

const card_template = preload("res://cards/card.tscn")

func _ready():
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "PlayerLibraryContainer::ready")

func initialize(player_library):
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "PlayerLibraryContainer::initializing")
	randomize()
	player_library.shuffle()
	for id in player_library:
		var card = card_template.instantiate()
		card.card_data = CardDB.get_card_by_id(id)
		card.init_data()
		card.name = card.card_data.card_name
		card.front_facing = false
		add_child(card)
		card.set_owner(self)
		card.update_card_view()
		card.position = Vector2.ZERO
		card.starting_position = Vector2.ZERO
		card.starting_rotation = global_rotation

