extends CharacterBody3D

@export var walk_speed : float = 3.0
@export var sprint_speed : float = 5.0
@export var jump_velocity : float = 20.0
@export var gravity : float = 2.0
@export var mouse_sensitivity : float = 0.005

@onready var head: Node3D = $Head
@onready var interaction_ray_cast: RayCast3D = $Head/InteractionRayCast

func _ready() -> void:
	# Hide mouse on game screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	interaction_ray_cast.check_interaction()

func _physics_process(delta: float) -> void:
	move()

func move() -> void:
	# Logic for movement, sprinting and jumping
	var is_sprinting: bool	
	var speed : float
	
	if is_on_floor():
		is_sprinting = Input.is_action_pressed("sprint")
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
	else:
		is_sprinting = false
		velocity.y -= gravity
	
	if is_sprinting:
		speed = sprint_speed
	else:
		speed = walk_speed
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	
	velocity.z = direction.z * speed
	velocity.x = direction.x * speed
	
	move_and_slide()

func _input(event: InputEvent) -> void:
	# Capture mouse motion for looking around
	if event is InputEventMouseMotion:
		look_around(event.relative)

func look_around(relative : Vector2) -> void:
	# Rotate the player and the head
	rotate_y(-relative.x * mouse_sensitivity)
	head.rotate_x(-relative.y * mouse_sensitivity)
	head.rotation_degrees.x = clampf(head.rotation_degrees.x, -60, 60)

func _unhandled_key_input(event: InputEvent) -> void:
	# Make mouse visible when pressing Esc key
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
