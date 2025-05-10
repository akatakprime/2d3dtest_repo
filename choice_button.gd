extends Button

var redirect : String

signal selected

func _button_pressed():
	selected.emit(redirect)

func _ready() -> void:
	pressed.connect(_button_pressed)
