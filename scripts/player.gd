extends CharacterBody3D

const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 100
const SENSITIVITY = 0.003
# Head Bob consts
const BOB_FREQUENY = 2.4
const BOB_AMPLITUDE = 0.08
# Camera fov consts
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var speed
var bob = 0.0

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float):
	# Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print("I just jumped!")
		velocity.y = JUMP_VELOCITY
	
	# Handle sprint
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Get the input direction and handle the movement
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	bob = delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = head_bob(bob)
	
	# TODO: not sure on fov logic. needs investigation into how this looks in game
	# FOV
	# var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	# var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	# camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()

func head_bob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQUENY) * BOB_AMPLITUDE
	pos.x = cos(time * BOB_FREQUENY / 2) * BOB_AMPLITUDE
	return pos
