extends Node2D

@onready var board = get_node("Board") as Board
@onready var player : Player = get_node("Player")
@onready var player_library_container = get_node("PlayerLibrary") as Node2D
@onready var player_hand_container = get_node("PlayerHand") as Node2D
@onready var game_state_machine = get_node("StateMachine") as StateMachine
var current_game_phase
var player_library = []
var player_hand = []
var player_graveyard = []
@export var max_hand_size = 16
var unit_starting_positions = {
	UnitData.UNIT_TYPE.PAWN: ["a2","b2","c2","d2","e2","f2","g2","h2"],
	UnitData.UNIT_TYPE.ROOK: ["a1","h1"],
	UnitData.UNIT_TYPE.KNIGHT: ["b1","g1"],
	UnitData.UNIT_TYPE.BISHOP: ["c1", "f1"],
	UnitData.UNIT_TYPE.QUEEN: ["d1"],
	UnitData.UNIT_TYPE.KING: ["e1"]
	}


# Called when the node enters the scene tree for the first time.
func _ready():
	current_game_phase = game_state_machine.state.name
	#TODO name dis better and dont call here yo
	get_node("%GameStateLabel").set_text(current_game_phase)
	EventBus.buses["GameBoardEvents"].card_selected.connect(_on_card_selected)
	EventBus.buses["GameBoardEvents"].tile_clicked.connect(_on_tile_clicked)
	EventBus.buses["GameBoardEvents"].game_state_changed.connect(_on_game_state_changed)
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "GameBoard::Setting up Player Library")
	player_library = player.get_current_deck_contents()
	player_library_container.initialize(player_library)
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "GameBoard::ready")


func draw_card():
	var top_card = player_library_container.get_child(0) as Card
	if !top_card:
		return
	player_library.remove_at(0)
	top_card.flip_card()
	move_to_hand(top_card)

func move_to_hand(card: Card):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "global_position", player_hand_container.get_card_destination(card.get_index()),2).from(player_library_container.global_position)
	player_hand.append(card.card_data.card_id)
	card.get_parent().remove_child(card)
	player_hand_container.add_child(card)
	card.set_owner(player_hand_container)

	await tween.finished

func move_to_graveyard():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_card_selected(card):
	EventBus.buses["LoggerEvents"].emit_signal("log_info", "GameBoard::Card selected: %s" % card.card_name)
	pass

func _on_tile_clicked(tile: BoardTile):
	EventBus.buses["LoggerEvents"].emit_signal("log_info", "GameBoard::Tile clicked: %s %s" % [tile.tile_data["board_position"], str(tile.tile_data["file"]) + tile.tile_data["rank"]])
	pass

func _on_game_state_changed(state: State):
	current_game_phase = state.name

func _process(delta):
	player_hand_container.update_hand()
	#TODO name dis better and dont call here yo
	get_node("%GameStateLabel").set_text(current_game_phase)
	pass

func draw_hand():
	for i in max_hand_size:
		draw_card()

