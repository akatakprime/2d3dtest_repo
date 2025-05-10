extends Node

@export var dialogue_box : Control
var json_file = "non_ink_json.json"

func _ready():
	dialogue_box.from_JSON(json_file)
