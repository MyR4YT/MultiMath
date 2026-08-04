extends CharacterBody2D

@export var delay_frames: int = 30 
@export var coyote_time: float = 0.15
var coyote_counter: float = 0.0
var position_history: Array[Vector2] = []
var clones = []

var SPEED = 300.0
const JUMP_VELOCITY = -400.0
var wall_grabbing = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not wall_grabbing:
		velocity += get_gravity() * delta
		coyote_counter -= delta  # Diminui o tempo fora do chão
		await get_tree().create_timer(0.016).timeout
		if not is_on_floor() and not wall_grabbing and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")):
			if SPEED <= 800:
				SPEED += 1.5
		else:
			SPEED = 300.0
	else:
		coyote_counter = coyote_time  # Reseta o tempo quando está no chão
	
	if is_on_floor(): 
		reset_timer()

	# Handle jump.
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor() or Input.is_action_just_pressed("ui_accept") and wall_grabbing or coyote_counter > 0.0:
			velocity.y = JUMP_VELOCITY
			coyote_counter = 0.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_wall() and not is_on_floor():
		if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and velocity.y >= 0:
			wall_grabbing = true
			velocity.y = 0
			SPEED = 300.0
		else:
			wall_grabbing = false
	else:
		wall_grabbing = false
	$"../Label".text = str(velocity.x)

	move_and_slide()
	position_history.insert(0, global_position)
	
	# O tamanho máximo do histórico agora depende de quantos clones você tem
	# Cada clone precisa de um "bloco" de frames de atraso
	var max_history_needed = delay_frames * (clones.size() + 1)
	
	if position_history.size() > max_history_needed:
		position_history.pop_back()
		
func reset_timer():
	await get_tree().create_timer(0.16).timeout
	if is_on_floor():
		SPEED = 300.0
