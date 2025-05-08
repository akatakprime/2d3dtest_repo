extends RichTextLabel

@onready var mask: ColorRect = $Mask as ColorRect
#tween.tween_callback($Sprite.queue_free)

var duration = 3.0

func _ready(): #like onStart()
	print("Ready")
	var tween = get_tree().create_tween()
	tween.tween_property(mask, "position:x", position.x + 920, duration)
	tween.tween_property(mask, "size:x", 0, duration)
	print("Done tweening")
