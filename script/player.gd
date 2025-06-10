extends CharacterBody3D

# --- Velocidade constante para frente ---
const FORWARD_SPEED = 0.5
const JUMP_VELOCITY = 10.0

# --- Variáveis para Gestos ---
const JUMP_GESTURE_THRESHOLD = 5.0
const SWIPE_GESTURE_THRESHOLD = 1.0
var can_jump_gesture = true
var can_swipe_gesture = true

# --- Variáveis para o sistema de 5 Pistas ---
const LANE_WIDTH = 2.0  # Distância entre cada pista
const LANE_CHANGE_SPEED = 12.0 # Velocidade da troca de pista.
var current_lane = 2 
var target_x_position = 0.0
# --------------------------------------------------------

@onready var animator = get_node("gdbot/AnimationPlayer") as AnimationPlayer
@export var hud: HUD

var coins := 0
var is_dead := false

var gravity = 0

func _ready():
	Input.set_use_accumulated_input(true)
	$JumpGestureCooldown.connect("timeout", _on_JumpGestureCooldown_timeout)
	$SwipeGestureCooldown.connect("timeout", _on_SwipeGestureCooldown_timeout)
	update_coin_display()

func detectar_gestos():
	# Gesto de Pulo
	var acceleration_y = Input.get_accelerometer().y
	if is_on_floor() and can_jump_gesture and acceleration_y > JUMP_GESTURE_THRESHOLD:
		gravity = -JUMP_VELOCITY
		can_jump_gesture = false
		$JumpGestureCooldown.start()

	# Gesto de Movimento Lateral
	var gyroscope_y = Input.get_gyroscope().y
	if can_swipe_gesture:
		var swipe_direction = 0
		if gyroscope_y > SWIPE_GESTURE_THRESHOLD:
			swipe_direction = -1 # Direita
			can_swipe_gesture = false
			$SwipeGestureCooldown.start()
		elif gyroscope_y < -SWIPE_GESTURE_THRESHOLD:
			swipe_direction = 1 # Esquerda
			can_swipe_gesture = false
			$SwipeGestureCooldown.start()
		
		if swipe_direction != 0:
			current_lane += swipe_direction
			current_lane = clamp(current_lane, 0, 4) # Garante que a pista fique entre 0 e 4

# Input de teclado também muda a PISTA alvo.
func handle_input():
	if Input.is_action_just_pressed("move_right"):
		current_lane += 1
	if Input.is_action_just_pressed("move_left"):
		current_lane -= 1
	
	# Garante que a pista fique sempre entre 0 e 4.
	current_lane = clamp(current_lane, 0, 4)


func _physics_process(delta: float) -> void:	
	detectar_gestos()
	handle_input()
	
	apply_gravity(delta)
	jump()
	
	# Define a posição X alvo com base na pista atual
	# Pista 2 (Centro) = 0. Pistas à esquerda são negativas, à direita são positivas.
	target_x_position = (current_lane - 2) * LANE_WIDTH
	
	# Move suavemente a posição X atual para a posição alvo
	position.x = lerp(position.x, target_x_position, delta * LANE_CHANGE_SPEED)
	
	# Define a velocidade para frente e a gravidade
	var applied_velocity = Vector3(0, -gravity, -FORWARD_SPEED)
	set_velocity(applied_velocity)
	move_and_slide()

	handle_animations()
	
func handle_animations():
	if not is_dead:
		if is_on_floor():
			animator.play("run", 0.3)
		else:
			if velocity.y > 0: # Subindo
				animator.play("jump", 0.3)
			else: # Caindo
				animator.play("fall", 0.3)
	else:
		get_parent().get_node("GameOver").visible = true
		get_tree().paused = true

func apply_gravity(delta):
	if not is_on_floor():
		gravity += 25 * delta
	
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		gravity = -JUMP_VELOCITY

	if gravity > 0 and is_on_floor():
		gravity = 0
		
func collect_coins():
	coins += 1
	update_coin_display()

func _on_JumpGestureCooldown_timeout():
	can_jump_gesture = true

func _on_SwipeGestureCooldown_timeout():
	can_swipe_gesture = true
	
func update_coin_display():
	if hud:
		hud.update_coin(coins)
