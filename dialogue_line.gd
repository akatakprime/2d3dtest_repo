extends RichTextLabel

@onready var mask: ColorRect = $Mask as ColorRect

var MAX_CHARS : float;
#tween.tween_callback($Sprite.queue_free)
var id : int
var text_length : int
var done_state = false
var duration = 3.0

signal done

func _ready(): #like onStart()
	var durationRatio :float = duration * text_length/MAX_CHARS #this way the line will be finished faster if there is less text
	var tween = get_tree().create_tween()
	tween.tween_property(mask, "position:x", position.x + 920, duration)
	tween.tween_property(mask, "size:x", 0, duration)
	#tween.connect("finished", on_tween_finished)
	await get_tree().create_timer(durationRatio).timeout
	done_state = true
	done.emit()
	#tween.tween_callback(on_tween_finished)
	
func skip():
	mask.position.x = 920
	mask.size.x = 0
	done_state = true
