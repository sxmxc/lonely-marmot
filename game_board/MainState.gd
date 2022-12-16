extends State

func enter():
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "MainState::entered")
