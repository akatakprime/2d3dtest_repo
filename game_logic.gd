extends Node

var dialogue_box = preload("res://dialogue_box.tscn")

func _ready():
	dialogue_box.feed_lines(["helloooooo", "hi"])
