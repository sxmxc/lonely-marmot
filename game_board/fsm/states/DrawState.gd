extends State

func enter():
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "DrawState::entered")
	if !game_board.player_library.is_empty():
		game_board.draw_card()
		await EventBus.buses["GameBoardEvents"].draw_card_finished
		exit("MainState")
	else:
		exit("EndState")
	pass
