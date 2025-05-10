extends Node

#var dialogue_box = preload("res://dialogue_box.tscn")
@export var dialogue_box : Control
#@export var json_file : JSON
var json_file = "non_ink_json.json"

func _ready():
	dialogue_box.from_JSON(json_file)
	'''
	dialogue_box.say([
		"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.", 
		"hi"
	])
	'''
