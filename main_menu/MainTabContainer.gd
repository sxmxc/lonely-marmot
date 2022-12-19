extends TabContainer

var tab_dict = {
	"Main": 0,
	"Settings": 1,
	"Card Library": 2,
	"Deck Builder": 3,
	"Dev Menu": 4
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_tab(tab : String):
	if tab_dict.has(tab):
		current_tab = tab_dict[tab]
	pass

func _on_setting_button_pressed():
	change_tab("Settings")
	pass # Replace with function body.


func _on_card_library_button_pressed():
	change_tab("Card Library")
	pass # Replace with function body.


func _on_deck_builder_button_pressed():
	change_tab("Deck Builder")
	pass # Replace with function body.


func _on_dev_button_pressed():
	change_tab("Dev Menu")
	pass # Replace with function body.


func _on_dev_back_button_pressed():
	change_tab("Main")
	pass # Replace with function body.


func _on_dev_scene_button_pressed():
	get_tree().change_scene_to_file("res://dev/dev.tscn")
	pass # Replace with function body.
