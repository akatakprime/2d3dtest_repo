extends Control
@export var diag_container : VBoxContainer
var diag_line = preload("res://dialogue_line.tscn")

#DIALOGUES (FULL CHARACTER SENTENCES)
var all_dialogues : Array
var current_dialogue_index = 0

#LINES (THE ACTUAL LINES ON THE TEXTBOX THAT GET UNCOVERED ONE BY ONE)
var all_lines : Array
var current_line_label : RichTextLabel
var current_line_index = 0
var MAX_CHARS = 55

#FROM JSON
var json_file : Dictionary
var current_container = "root"
var choice_button = preload("res://choice_button.tscn") 
@export var choice_container : VBoxContainer

var are_choices = false

func _ready() -> void:
	visible = false

func break_down_lines(str_:String):
	var number_of_extra_lines:int = floor(str_.length()/MAX_CHARS) #if single line, will == 0
	for index in range(0, str_.length()): #add extra line for every \n character
		if str_[index] == '\n':
			number_of_extra_lines += 1
	all_lines = []
	for i in number_of_extra_lines:
		var last_space_index = 0
		for index in range(0, MAX_CHARS):
			if str_[index] == '\n':
				index += 1
				last_space_index = index
				break
			elif str_[index] == ' ':
				last_space_index = index
		all_lines.push_back(str_.substr(0, last_space_index)) #push first 60 chars (up to last full word)
		str_ = str_.substr(last_space_index) #remove from str_
	all_lines.push_back(str_) #pushes final line
	print("All lines: ", all_lines)

func proceed_line():
	if current_line_index < all_lines.size()-1: #make sure you're not out of bounds
			current_line_index += 1
			display_current_line()

func display_current_line():
	#print("Displaying next line")
	var newline = diag_line.instantiate()
	newline.id = current_line_index
	newline.text = "[color=black]"+all_lines[current_line_index]+"[/color]"
	newline.text_length = all_lines[current_line_index].length()
	newline.MAX_CHARS = MAX_CHARS
	current_line_label = newline
	newline.done.connect(proceed_line)
	diag_container.add_child(newline)

func clear_children(container):
	for n in container.get_children():
		container.remove_child(n)
		n.queue_free() 

func display_current_dialogue():
	#clear any old dialogue
	clear_children(diag_container)
	current_line_index = 0
	break_down_lines(all_dialogues[current_dialogue_index])
	display_current_line()
	if current_dialogue_index == all_dialogues.size()-1:
		#if it is the last dialogue in the array, display the choices at the end
		if json_file[current_container].has("choices"):
			set_choices(json_file[current_container].choices)
	
func skip_dialogue_animation():
	current_line_label.skip()
	if (current_line_index < all_lines.size()-1):
		for x in range(current_line_index+1, all_lines.size()):
			current_line_index+=1
			display_current_line()
			current_line_label.skip()

func say(dialogues : Array):
	visible = true
	all_dialogues=dialogues
	current_dialogue_index = 0
	#print("ALL DIALOGUES: ", all_dialogues)
	display_current_dialogue()
	
func advance_dialogue():
	if current_line_label.done_state == true:
		#print("Done is true")
		if current_dialogue_index < all_dialogues.size()-1:
			current_dialogue_index += 1
			display_current_dialogue()
		elif are_choices == false:
			#if you've finished all the dialogues, close the box
			visible = false
	else:
		skip_dialogue_animation()
		
#CLICK TO ADVANCE DIALOGUE
func _input(event):
	if visible == true:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				advance_dialogue()
				
#clear dialogue array on visible
func _on_visibility_changed(visible_state):
	if visible_state:
		#print("DialogueBox is now visible")
		all_dialogues = []

func change_container(new_container:String):
	are_choices = false
	current_container = new_container
	display_current_container()

func set_choices(choices:Array):
	are_choices = true
	for choice in choices:
		var newchoice = choice_button.instantiate()
		newchoice.text = choice.text
		newchoice.redirect = choice.jump
		newchoice.selected.connect(change_container)
		print("Adding choice: ", newchoice)
		choice_container.add_child(newchoice)

#JSON RELATED
func display_current_container():
	clear_children(choice_container)
	if json_file:
		say(json_file[current_container].text)

func from_JSON(file:String):
	current_container = "root"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	if json_as_dict:
		print(json_as_dict)
		json_file = json_as_dict
		display_current_container()
