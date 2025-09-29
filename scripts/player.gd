extends CharacterBody3D

signal coin_collected

@export_subgroup("Properties")
@export var movement_speed = 8.0
@export var jump_strength = 7.0
@export var rotation_speed = 5.0

var jump_single = true
var jump_double = true
var input_vector: Vector3 = Vector3.ZERO

@onready var model = $BigVegas
@onready var animation = $"BigVegas/AnimationPlayer"

func _physics_process(delta):
	handle_input(delta)
	handle_movement(delta)
	handle_animation(delta)

# ------------------------
# Input
# ------------------------
func handle_input(delta):
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.z = Input.get_axis("move_forward", "move_back")

	if input_vector.length() > 1:
		input_vector = input_vector.normalized()

	# หมุนซ้าย/ขวา
	if abs(input_vector.x) > 0.01:
		rotation.y += -input_vector.x * rotation_speed * delta

	# Jump
	if Input.is_action_just_pressed("jump") and (jump_single or jump_double) and is_on_floor():
		velocity.y = jump_strength
		if jump_single:
			jump_single = false
			jump_double = true
		else:
			jump_double = false

# ------------------------
# Movement & Gravity
# ------------------------
func handle_movement(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= 25.0 * delta
	else:
		velocity.y = max(velocity.y, 0)
		jump_single = true

	# Forward/back movement
	var forward = -transform.basis.z
	forward.y = 0
	forward = forward.normalized()
	velocity.x = forward.x * input_vector.z * movement_speed
	velocity.z = forward.z * input_vector.z * movement_speed

	# Move character
	move_and_slide()  # ใช้ velocity ของ CharacterBody3D ตรงๆ

# ------------------------
# Animation
# ------------------------
func handle_animation(delta):
	if not is_on_floor():
		if animation.current_animation != "jump":
			animation.play("jump")
	elif input_vector.z != 0:
		if animation.current_animation != "running":
			animation.play("running")
	else:
		if animation.current_animation != "idle":
			animation.play("idle")

# ------------------------
# Collect coins
# ------------------------
func collect_coin():
	coin_collected.emit(1)
