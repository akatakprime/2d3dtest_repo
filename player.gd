extends CharacterBody3D
#gets AnimatedSprite3d once it's loaded
@onready var sprite: AnimatedSprite3D = $SpriteAnimator as AnimatedSprite3D #typecast

@export var move_speed : float = 3.0 #@export is like [SerializeField]
@export var jump_speed : float = 3.0 #going upward in Godot is a negative axis
@export var fall_speed : float = -10.0

const GRAVITY : float = -10.0

var jump_start = false
var in_air = false

var face_direction = 1

func _ready(): #like onStart()
	#sprite.animation_finished.connect(on_jumpanim_finished)
	pass

#returns void
func _physics_process(delta: float) -> void: #like FixedUpdate() and delta = Time.deltaTime
	apply_gravity(delta) #gravity is applied every frame
	if !jump_start and !in_air:
		handle_movement()
	handle_jump()
	move_and_slide() #applies any changes we make to velocity (important)
	flip_character()
	handle_animations()

func apply_gravity(delta : float) -> void:
	#velocity comes from our CharacterBody3D
	velocity.y += GRAVITY * delta

func handle_movement() -> void:
	#Input.get_axis --> first argument returns -1 if active, second returns 1 and when none are held it returns 0
	var movement_direction : float = Input.get_axis("move_left", "move_right")
	velocity.x = 0.0
	if movement_direction < 0: #going left
		velocity.x = -move_speed
	elif movement_direction > 0:
		velocity.x = move_speed

func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		jump_start = true
	if is_on_floor():
		if in_air: #if switching from air to floor, play landing animation
			sprite.play("Land") #doesn't work rn
		in_air = false
	elif jump_start and in_air:
		velocity.x = face_direction * jump_speed #add forward velocity once in the air (since other movement script is disabled)
		jump_start = false
	else:
		in_air = true
	clampf(velocity.y, jump_speed, fall_speed) #sets minimum and maximum for velocity.y

'''
func on_jumpanim_finished() -> void:
	print("Animation finished: ", sprite.animation)
	if sprite.animation == "JumpBegin":
		velocity.y = jump_speed
		velocity.x = face_direction*jump_speed
		jump_start = false
'''
		
func flip_character() -> void:
	if velocity.x < 0:
		sprite.flip_h = true
		face_direction = -1
	elif velocity.x > 0:
		sprite.flip_h = false
		face_direction = 1
		
func handle_animations() -> void:
	if in_air or jump_start:
		if velocity.y > 0:
			sprite.play("JumpUp")
		else:
			sprite.play("JumpDown")
	else:
		if velocity == Vector3.ZERO:
			#idle animation
			sprite.play("Idle")
		else:
			sprite.play("Walk")
		
