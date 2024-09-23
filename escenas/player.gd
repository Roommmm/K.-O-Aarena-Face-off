extends CharacterBody3D

@onready var camera = $Camera3D
@onready var animation_player: AnimationPlayer = $Camera3D/AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if Input.is_action_just_pressed("atacarr") \
				 and animation_player.current_animation != "atacar":
			play_attack_efect()
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if animation_player.current_animation == "atacar":
		pass
	elif input_dir != Vector2.ZERO and is_on_floor():
		animation_player.play("move")
	else:
		animation_player.play("idle")
	move_and_slide()
	
func play_attack_efect():
	animation_player.stop()
	animation_player.play("atacar")
