extends CharacterBody2D

@export var delay_frames: int = 30 
@export var coyote_time: float = 0.15
@onready var tile_map: TileMapLayer = $"../TileSet1"
@export var wall_jump_force_x := 300.0
@export var wall_jump_force_y := -400.0
var coyote_counter: float = 0.0
var position_history: Array[Vector2] = []
var clones = []
@onready var anim = $AnimatedSprite2D

var SPEED = 300.0
const JUMP_VELOCITY = -600.0
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
	
	anim.flip_h = velocity.x < 0
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if not is_on_floor() and not wall_grabbing:
		velocity += get_gravity() * delta

	var can_wall_jump_tile = is_on_valid_wall_tile()

	if is_on_wall() and not is_on_floor() and can_wall_jump_tile:
		if (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and velocity.y >= 0:
			wall_grabbing = true
			velocity.y = 0 # Mantém o jogador preso na parede
		else:
			wall_grabbing = false
	else:
		wall_grabbing = false

	if wall_grabbing and Input.is_action_just_pressed("ui_accept"):
		var wall_normal = get_wall_normal().x
		
		velocity.x = wall_normal * wall_jump_force_x
		velocity.y = wall_jump_force_y
		wall_grabbing = false

	$"../Label".text = str(velocity.x)

	# move_and_slide DEVE vir no final
	move_and_slide()

	position_history.insert(0, global_position)
	
	var max_history_needed = delay_frames * (clones.size() + 1)
	
	if position_history.size() > max_history_needed:
		position_history.pop_back()

func is_on_valid_wall_tile() -> bool:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is TileMap or collider is TileMapLayer:
			var hit_position = collision.get_position() - collision.get_normal() * 2.0
			var tile_pos = collider.local_to_map(collider.to_local(hit_position))
			
			var tile_data = collider.get_cell_tile_data(tile_pos)
			if tile_data:
				# Substitua "can_wall_jump" pelo nome exato da sua Custom Data Layer
				return tile_data.get_custom_data("Walljump") == true
				
	return false

func reset_timer():
	await get_tree().create_timer(0.16).timeout
	if is_on_floor():
		SPEED = 300.0
