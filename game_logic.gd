extends Node

@export var dialogue_box : Control
var json_file = "non_ink_json.json"

func _ready():
	SaveSystem.edit("name", "kiki")
	#dialogue_box.from_JSON(json_file)
