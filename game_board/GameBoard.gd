extends Node2D

const card_template = preload("res://cards/card.tscn")

@onready var player : Player = get_node("Player")
@onready var player_library_container = get_node("PlayerLibrary")
@onready var player_hand_container = get_node("PlayerHand") as Node2D
var player_library = []
var player_hand = []
var player_graveyard = []
var max_hand_size = 7


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	player_library = player.get_current_deck_contents()
	player_library.shuffle()
	for id in player_library:
		var card = card_template.instantiate()
		card.card_data = CardDb.get_card_by_id(id)
		card.init_data()
		card.name = card.card_data.card_name
		card.front_facing = false
		player_library_container.add_child(card)
		card.update_card_view()
		card.position = Vector2.ZERO
		card.starting_position = Vector2.ZERO
		card.starting_rotation = card.rotation

	for i in max_hand_size:
		draw_card()
	update_hand()
	pass # Replace with function body.

func draw_card():
	var top_card = player_library_container.get_child(0) as Card
	if !top_card:
		return
	var top_card_id = player_library.pop_front()
	player_library_container.remove_child(top_card)
	player_hand.append(top_card_id)
	player_hand_container.add_child(top_card)
	top_card.position = Vector2.ZERO
	top_card.starting_position = Vector2.ZERO
	top_card.front_facing = true

func update_hand():
	var spread_curve = load("res://game_board/spread_curve.tres") as Curve
	var rotation_curve = load("res://game_board/rotation_curve.tres") as Curve
	for card in player_hand_container.get_children() :
		var hand_ratio = 0.5
		if player_hand_container.get_child_count() > 1:
			hand_ratio = float(card.get_index()) / float(player_hand_container.get_child_count() -1)
		var destination = Vector2.ZERO
		destination.x += spread_curve.sample(hand_ratio) * 150
		card.position = Vector2(destination.x - (card.card_size.x/2), destination.y - (card.card_size.y/2))
		card.starting_position = card.position
		card.rotation = rotation_curve.sample(hand_ratio) * 0.3
		card.starting_rotation = card.rotation
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
