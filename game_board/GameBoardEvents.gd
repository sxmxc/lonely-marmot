extends "res://event_bus/Events.gd"

signal card_selected(card: Card)
signal card_dropped_on_board(tile: BoardTile)
signal card_added_to_hand

signal redraw_hand_requested
signal draw_card_requested
signal discard_hand_requested

signal draw_card_finished
signal draw_hand_finished
signal discard_hand_finished

signal tile_clicked(tile: BoardTile)



signal game_state_changed(new_state: State)

func _ready():
	card_selected.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "card_selected"))
	card_dropped_on_board.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "card_dropped"))
	card_added_to_hand.connect(func(): EventBus.buses["LoggerEvents"].emit_signal("log_event", "card_added_to_hand"))
	redraw_hand_requested.connect(func(): EventBus.buses["LoggerEvents"].emit_signal("log_event", "redraw_hand_requested"))
	draw_card_requested.connect(func(): EventBus.buses["LoggerEvents"].emit_signal("log_event", "draw_card_requested"))
	discard_hand_requested.connect(func(): EventBus.buses["LoggerEvents"].emit_signal("log_event", "discard_hand_requested"))
	draw_card_finished.connect(func(): EventBus.buses["LoggerEvents"].emit_signal("log_event", "draw_card_finished"))
	draw_hand_finished.connect(func(): EventBus.buses["LoggerEvents"].emit_signal("log_event", "draw_hand_finished"))
	discard_hand_finished.connect(func(): EventBus.buses["LoggerEvents"].emit_signal("log_event", "draw_hand_finished"))
	tile_clicked.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "tile_clicked"))
	game_state_changed.connect(func(_args): EventBus.buses["LoggerEvents"].emit_signal("log_event", "game_state_changed"))
