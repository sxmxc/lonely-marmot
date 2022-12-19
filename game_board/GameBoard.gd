extends Node2D
class_name GameBoard

@onready var board = get_node("Board") as Board
@onready var player : Player = get_node("Player")
@onready var player_library_container = get_node("PlayerLibrary") as Node2D
@onready var player_hand_container = get_node("PlayerHand") as Node2D
@onready var player_graveyard_container = get_node("PlayerGraveyard") as Node2D
@onready var game_state_machine = get_node("StateMachine") as StateMachine
var current_game_phase := "NONE"
var player_library = []
var player_hand = []
var player_graveyard = []
var max_hand_size = GlobSettings.PLAYER_MAX_HAND
var is_dragging_card := false
var dragging_card : Card = null

var unit_starting_positions = {
	GlobConsts.UNIT_TYPE.PAWN: ["a2","b2","c2","d2","e2","f2","g2","h2"],
	GlobConsts.UNIT_TYPE.ROOK: ["a1","h1"],
	GlobConsts.UNIT_TYPE.KNIGHT: ["b1","g1"],
	GlobConsts.UNIT_TYPE.BISHOP: ["c1", "f1"],
	GlobConsts.UNIT_TYPE.QUEEN: ["d1"],
	GlobConsts.UNIT_TYPE.KING: ["e1"]
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.buses["GameBoardEvents"].card_selected.connect(_on_card_selected)
	EventBus.buses["GameBoardEvents"].tile_clicked.connect(_on_tile_clicked)
	EventBus.buses["GameBoardEvents"].game_state_changed.connect(_on_game_state_changed)
	EventBus.buses["GameBoardEvents"].draw_card_requested.connect(draw_card)
	EventBus.buses["GameBoardEvents"].redraw_hand_requested.connect(draw_hand)
	EventBus.buses["GameBoardEvents"].discard_hand_requested.connect(discard_hand)
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "GameBoard::Setting up Player Library")
	player_library = player.get_current_deck_contents()
	player_library_container.initialize(player_library)
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "GameBoard::ready")


func draw_card():
	if !player_library.is_empty():
		var top_card = player_library_container.get_top_card() as Card
		player_library.remove_at(0)
		top_card.flip_card()
		move_to_hand(top_card)
	else:
		EventBus.buses["LoggerEvents"].emit_signal("log_message", "GameBoard::Library empty")


func move_to_hand(card: Card):
	card.is_moving = true
	var center_destination := GlobUtils.get_screen_center() - GlobUtils.get_center(card.size)
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", center_destination, 2).from(player_library_container.global_position)
	tween.tween_property(card, "global_position", player_hand_container.get_global_card_destination(card.get_index()-1),1).from(center_destination)
	player_hand.append(card.card_data.card_id)
	player_hand_container.add_card(card)
	await tween.finished
	EventBus.buses["GameBoardEvents"].emit_signal("draw_card_finished")
	card.is_moving = false


func move_to_graveyard(card: Card):
	card.in_graveyard = true
	card.get_node("Highlight").visible = false
	card.highlighted = false
	card.dragging = false
	card.starting_rotation = player_graveyard_container.global_rotation
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", player_graveyard_container.global_position - GlobUtils.get_center(card.size) ,1)
	for i in player_hand.size() - 1:
		if player_hand[i] == card.card_data.card_id:
			player_hand.remove_at(i)
			break
	player_graveyard.append(card.card_data.card_id)
	player_graveyard_container.add_card(card)
	card.unmagnify_card()
	await tween.finished
	card.is_moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_card_selected(card):
	EventBus.buses["LoggerEvents"].emit_signal("log_info", "GameBoard::Card selected: %s" % card.card_name)
	dragging_card = card
	is_dragging_card = true
	pass

func _on_tile_clicked(tile: BoardTile):
	EventBus.buses["LoggerEvents"].emit_signal("log_info", "GameBoard::Tile clicked: %s %s" % [tile.tile_data["board_position"], str(tile.tile_data["file"]) + tile.tile_data["rank"]])
	if dragging_card:
		EventBus.buses["LoggerEvents"].emit_signal("log_info", "GameBoard::Card %s requesting tile: %s %s" % [dragging_card.card_name,tile.tile_data["board_position"], str(tile.tile_data["file"]) + tile.tile_data["rank"]])
		if tile.valid and !tile.current_unit:
			var unit = load("res://units/Unit.tscn").instantiate()
			unit.initialize(dragging_card)
			tile.add_unit(unit)
			move_to_graveyard(dragging_card)
			is_dragging_card = false
			dragging_card = null
			board.add_child(unit)
			unit.position = tile.position
	pass

func _on_game_state_changed(state: State):
	current_game_phase = state.name

func _process(delta):

	#TODO name dis better and dont call here yo
	get_node("%GameStateLabel").set_text("Turn phase: " + current_game_phase)
	pass

func draw_hand():
	for i in max_hand_size:
		draw_card()
		await get_tree().create_timer(.5).timeout
	EventBus.buses["GameBoardEvents"].emit_signal("draw_hand_finished")


func discard_hand():
	for card in player_hand_container.get_cards():
		move_to_graveyard(card)
		await get_tree().create_timer(.5).timeout
	EventBus.buses["GameBoardEvents"].emit_signal("discard_hand_finished")
