extends State

func enter():
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "DrawState::entered")
	#TODO clean up this shyty shyte
	game_board.draw_hand()
	await get_tree().create_timer(2.0).timeout
	exit("MainState")
	pass
