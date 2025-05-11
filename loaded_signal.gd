extends VBoxContainer
signal loaded
func _ready() -> void:
	print("Ready!")
	loaded.emit()
