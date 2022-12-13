extends Node2D



func _ready():
	EventBus.buses["LoggerEvents"].log_message.connect(log_message)
	EventBus.buses["LoggerEvents"].log_event.connect(log_event)
	EventBus.buses["LoggerEvents"].log_info.connect(log_info)
	test()

func log_message(msg : String):
	var format_string = "Message received"
	Print.logger(Print.GREEN_BOLD,format_string, Print.GREEN, msg)

func log_event(event: String):
	var format_string = "Event received"
	Print.logger(Print.BLUE_BOLD, format_string, Print.BLUE, event)

func log_info(info: String):
	var format_string = "Info received"
	Print.logger(Print.WHITE_BOLD, format_string, Print.WHITE, info)

func test():
	Print.line(Print.GREEN_BOLD, "LOGGER| Beginning logger test")
	Print.line(Print.YELLOW, "LOGGER| If this line is not in yellow you need to change some system registers")
	Print.line(Print.RED, 'LOGGER| The colors are only visible on the console, not on the engine output panel')
	Print.logger(Print.YELLOW, "Testing logger integration function", Print.BLUE, "with a value color")
	EventBus.buses["LoggerEvents"].emit_signal("log_event", "Test Log Event")
	EventBus.buses["LoggerEvents"].emit_signal("log_message", "Test Log Message")
	EventBus.buses["LoggerEvents"].emit_signal("log_info", "Test Log Info")
	Print.line(Print.GREEN_BOLD, "LOGGER| Test Completed")
