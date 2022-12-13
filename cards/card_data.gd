extends Resource
class_name CardData

enum CARD_TYPE { UNIT, SPELL, TRAP}

@export var card_name: String
@export var card_id: String
@export var card_ability_text: String
@export var card_flavor_text: String
@export var card_image: Texture2D
@export var card_value: int
@export var card_type: CARD_TYPE
@export var card_target_type: UnitData.UNIT_TYPE

