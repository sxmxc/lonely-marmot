extends Node2D

var _db : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	load_from_disk()
	Logger.log_message("CardDB::ready")
	pass # Replace with function body.


func get_card_by_id(id: String):
	if _db.has(id):
		return _db[id]
	return null

func get_card_by_name(arg: String):
	for key in _db.keys():
		if _db[key].card_name == arg:
			return _db[key]

func get_card_id(arg: String):
	for key in _db.keys():
		if _db[key].card_name == arg:
			return key

func has_card(id: String):
	return _db.has(id)

func insert_into_db(card: CardData):
	if !card:
		return false
	if _db.has(card.card_id):
		return false
	_db[card.card_id] = card
	return true

func remove_from_db(id: int):
	if _db.has(id):
		_db.erase(id)


func load_from_disk(path: String = "res://cards/data"):
	Logger.log_message("CardDB::Loading data from disk")
	#EventBus.buses["LoggerEvents"].emit_signal("log_message","Loading data from disk")
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
				#print("Found directory: " + file_name)
			else:
				#print("Found file: " + file_name)
				var card = load(dir.get_current_dir() + "/" + file_name) as CardData
				var res = insert_into_db(card)
				if res:
					pass
					#print("Added card to DB: " + card.card_name)
				file_name = dir.get_next()
	else:
		Logger.log_message("CardDB::An error occurred when trying to access the path.")
		#EventBus.buses["LoggerEvents"].emit("log_message","An error occurred when trying to access the path.")
