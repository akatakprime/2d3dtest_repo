extends Button

@export var type:int

var possible_items = SaveSystem.player_data["possible_items"]

var rng = RandomNumberGenerator.new()

func _pressed() -> void:
	var random_item = possible_items[rng.randi_range(0, possible_items.size()-1)]
	if type == 1:
		SaveSystem.add_item(random_item)
	else:
		var error = SaveSystem.remove_item(random_item)
		if error:
			print(error)
