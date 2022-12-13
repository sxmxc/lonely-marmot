extends Resource
class_name UnitData

enum UNIT_TYPE { PAWN, ROOK, BISHOP, KNIGHT, KING, QUEEN}

@export var unit_type : UNIT_TYPE
@export var unit_name : String
@export var unit_description : String
@export var unit_starting_positions: Array[String]
#@export var unit_abilities : Array
#@export var unit_movement
