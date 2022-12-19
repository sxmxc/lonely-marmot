extends State

func enter():
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "PreGameState::entered")
	#TODO clean up this shyty shyte
	await get_node("%TopScreenButton").pressed
	get_node("%TopScreenButton").visible = false
	exit("DrawState")
