extends "res://event_bus/Events.gd"

signal card_selected(card: Card)
signal card_dropped_on_board(tile: BoardTile)
signal tile_clicked(tile: BoardTile)

signal game_state_changed(new_state: State)

func _ready():
	card_selected.connect(func(_card): EventBus.buses["LoggerEvents"].emit_signal("log_event", "card_selected"))
	card_dropped_on_board.connect(func(_tile): EventBus.buses["LoggerEvents"].emit_signal("log_event", "card_dropped"))
	tile_clicked.connect(func(_tile): EventBus.buses["LoggerEvents"].emit_signal("log_event", "tile_clicked"))
	game_state_changed.connect(func(_tile): EventBus.buses["LoggerEvents"].emit_signal("log_event", "game_state_changed"))
