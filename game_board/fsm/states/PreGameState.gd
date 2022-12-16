extends State

func enter():
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "PreGameState::entered")
	# Exit 2 seconds later
	await get_node("%TopScreenButton").pressed
	get_node("%TopScreenButton").visible = false
	exit("DrawState")
