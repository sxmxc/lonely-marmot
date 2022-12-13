extends Control
class_name Card

@onready var card_back = get_node("CardBack")
@onready var card_front = get_node("CardFront")
@onready var card_image = get_node("CardFront/CardImage") as TextureRect
@onready var card_name_label = get_node("CardFront/CardName") as Label
@onready var card_target_label = get_node("%CardTargetTypeLabel") as Label
@onready var card_flavor_text_label = get_node("CardFront/FlavorText") as RichTextLabel
@onready var card_ability_text_label = get_node("CardFront/AbilityText") as RichTextLabel
@onready var card_type_label = get_node("%CardTypeLabel") as Label

@export var card_data : CardData
@export var front_facing = false

var dragging

var starting_position
var starting_rotation
var card_size

var card_name
var card_flavor_text
var card_ability_text
var card_value
var card_type
var card_target_type

# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = position
	card_front.visible = front_facing
	card_back.visible = !front_facing
	card_size = $CardBack.size
	pass # Replace with function body.


func _process(_delta):
	card_front.visible = front_facing
	card_back.visible = !front_facing


func _input(_event):
	if dragging:
		global_position = get_global_mouse_position()

func init_data():
	card_name = card_data.card_name
	card_ability_text = card_data.card_ability_text
	card_flavor_text = card_data.card_flavor_text
	card_value = card_data.card_value
	card_type = card_data.card_type
	card_target_type = card_data.card_target_type

func flip_card():
	front_facing = !front_facing
	card_front.visible = front_facing
	card_back.visible = !front_facing

func update_card_view():
	card_name_label.set_text(card_name)
	card_ability_text_label.set_text(card_ability_text)
	card_flavor_text_label.set_text(card_flavor_text)
	card_image.texture = card_data.card_image
	card_type_label.text = CardData.CARD_TYPE.keys()[card_type]
	card_target_label.text = UnitData.UNIT_TYPE.keys()[card_target_type]





func _on_mouse_entered():
	if !dragging:
		get_node("Highlight").visible = true
		z_index = 10
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(self, "position", Vector2(position.x, position.y - 200), .5)
		tween.tween_property(self, "rotation", 0, .5)
		tween.tween_property(self, "scale", Vector2(1.5,1.5), .5)
	pass # Replace with function body.


func _on_mouse_exited():
	if !dragging:
		get_node("Highlight").visible = false
		z_index = 0
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(self, "position", starting_position, .5)
		tween.tween_property(self, "rotation", starting_rotation, .5)
		tween.tween_property(self, "scale", Vector2(1,1), .5)
	pass # Replace with function body.


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT && event.pressed:
			if !dragging:
				dragging = true
				var tween = get_tree().create_tween()
				tween.set_parallel(true)
				tween.tween_property(self, "scale", Vector2(.5,.5), .5)
				EventBus.buses["GameBoardEvents"].emit_signal("card_selected", self)
			else:
				dragging = false

	pass # Replace with function body.
