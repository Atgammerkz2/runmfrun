extends CharacterBody3D


const SPEED = 200.0
const JUMP_VELOCITY = 10.0
@onready var animator = get_node("gdbot/AnimationPlayer") as AnimationPlayer
@onready var coins_container: HBoxContainer = $"../HUD/coins_container"
var coins := 0

#@export var view : Node3D
var gravity = 0
var movement_velocity: Vector3
var rotation_direction: float

func _physics_process(delta: float) -> void:
	handle_input(delta)
	apply_gravity(delta)
	jump(delta)
	handle_animations()
	
	var applied_velocity: Vector3
	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity
	velocity = applied_velocity
	
	move_and_slide()
	
	#if Vector2(velocity.z, velocity.x).length() > 0:
	#	rotation_direction = Vector2(velocity.z, velocity.x).angle()
	#rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

func handle_input(delta):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_backward")
	#input = input.rotated(Vector3.UP, rotation.y).normalized()
	
	velocity = input * SPEED * delta
	
func handle_animations():
	if is_on_floor():
		#if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			#animator.play("run", 0.3)
		#else:
			animator.play("run", 0.3)
	else:
		animator.play("jump", 0.3)
		
	if not is_on_floor() and gravity > 2:
		animator.play("fall", 0.3)

func apply_gravity(delta):
	if not is_on_floor():
		gravity += 25 * delta
	
func jump(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity = -JUMP_VELOCITY

	if gravity > 0 and is_on_floor():
		gravity = 0
		
func collect_coins():
	coins += 1
	coins_container.update_coin(coins)
