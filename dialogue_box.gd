extends Control
@export var diag_container : VBoxContainer
var diag_line = preload("res://dialogue_line.tscn")

func feed_lines(lines : Array):
	for str_ in lines:
		var newline = diag_line.instantiate()
		newline.text = "[color=black]"+str_+"[/color]"
		diag_container.add_child(newline)
