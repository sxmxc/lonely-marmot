extends Node2D

var spread_curve = load("res://game_board/spread_curve.tres") as Curve
var rotation_curve = load("res://game_board/rotation_curve.tres") as Curve
var height_curve = load("res://game_board/height_curve.tres") as Curve

func update_hand():
	for card in get_children() :
		var destination = get_card_destination(card.get_index())
		if !card.highlighted:
			card.position = Vector2(destination.x - (card.card_size.x/2), destination.y - (card.card_size.y/2))
			card.starting_position = card.position
			card.rotation = rotation_curve.sample(get_hand_ratio(card.get_index())) * 0.3
			card.starting_rotation = card.rotation

func get_card_destination(idx):
	var hand_ratio = get_hand_ratio(idx)
	var destination = Vector2.ZERO
	destination.x += spread_curve.sample(hand_ratio) * 150
	destination.y -= height_curve.sample(hand_ratio) * 20
	return destination

func get_hand_ratio(idx):
	var hand_ratio = 0.5
	if get_child_count() > 1:
		hand_ratio = float(idx) / float(get_child_count() -1)
	return hand_ratio
