extends Node2D
class_name Player

@export var _data: PlayerData
@export var _save_file: String = "res://player/data/player_data.res"


#@onready var _deck_node = get_node("Deck")
@onready var _player_menu = get_node("UI/player_menu") as PlayerMenu

var menu_visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.buses["PlayerEvents"].card_collected.connect(_on_card_collected)
	EventBus.buses["PlayerEvents"].deck_created.connect(_on_deck_created)
	EventBus.buses["PlayerEvents"].deck_equipped.connect(_on_deck_equipped)
	EventBus.buses["PlayerEvents"].deck_updated.connect(_on_deck_updated)
	EventBus.buses["PlayerEvents"].deck_deleted.connect(_on_deck_deleted)

	if !_data:
		if ResourceLoader.exists(_save_file):
			_data = ResourceLoader.load(_save_file)
		else:
			_data = PlayerData.new()
			ResourceSaver.save(_data,_save_file)
	_player_menu.set_player_menu_data(_data)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("player_menu"):
		if menu_visible:
			close_menu()
		else:
			open_menu()
	pass

func add_card_to_collection(id: String):
	if CardDB.has_card(id):
		_data.player_collected_cards.append(id)
		print(CardDB.get_card_by_id(id).card_name + " added to player collection")
		save_player_data()
		return true
	return false

func save_player_data():
	if !_data:
		if ResourceLoader.exists(_save_file):
			_data = ResourceLoader.load(_save_file)
		else:
			_data = PlayerData.new()
	ResourceSaver.save(_data,_save_file)



func open_menu():
	_player_menu.set_player_menu_data(_data)
	_player_menu.visible = true
	menu_visible = true
	get_tree().paused = true
	pass
func close_menu():
	_player_menu.visible = false
	menu_visible = false
	get_tree().paused = false
	pass

func _on_card_collected(id: String):
	if add_card_to_collection(id):
		EventBus.buses["PlayerEvents"].emit_signal("card_added", true)
		EventBus.buses["PlayerEvents"].emit_signal("player_data_updated")
	else:
		EventBus.buses["PlayerEvents"].emit_signal("card_added", false)

func _on_deck_created(deck_name: String):
	create_deck(deck_name)

func _on_deck_equipped(deck_name: String):
	equip_deck(deck_name)

func _on_deck_deleted(deck_name: String):
	delete_deck(deck_name)

func _on_deck_updated(_deck_name: String):
	save_player_data()
	EventBus.buses["PlayerEvents"].emit_signal("player_data_updated")

func delete_deck(deck_name: String):
	if _data.player_decks.has(deck_name):
		_data.player_decks.erase(deck_name)
		save_player_data()
		EventBus.buses["PlayerEvents"].emit_signal("player_data_updated")

func create_deck(deck_name: String):
	if !_data.player_decks.has(deck_name):
		_data.player_decks[deck_name] = []
		save_player_data()
		EventBus.buses["PlayerEvents"].emit_signal("player_data_updated")

func equip_deck(deck_name: String):
	if _data.player_decks.has(deck_name):
		_data.player_current_deck = deck_name
		save_player_data()
		EventBus.buses["PlayerEvents"].emit_signal("player_data_updated")

func add_card_to_deck(deck_name: String, card_id: String):
	if _data.player_collected_cards.has(card_id):
		if _data.player_decks.has(deck_name):
			_data.player_decks[deck_name].append(card_id)
			save_player_data()
			EventBus.buses["PlayerEvents"].emit_signal("player_data_updated")


func remove_card_from_deck(deck_name: String, card_id: String):
	if _data.player_decks.has(deck_name):
		if _data.player_decks[deck_name].has(card_id):
			_data.player_decks[deck_name].erase(card_id)
			save_player_data()
			EventBus.buses["PlayerEvents"].emit_signal("player_data_updated")

func get_current_deck_name():
	return _data.player_current_deck

func get_current_deck_contents():
	return _data.player_decks[_data.player_current_deck]
