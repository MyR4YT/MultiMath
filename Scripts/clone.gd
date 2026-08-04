extends Area2D

var player = null
var touch = false

@export var follow_speed: float = 10.0 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not touch:
		return
		
	var history = player.position_history
	
	var my_index = player.clones.find(self)
	
	if my_index == -1:
		return # Caso o clone seja destruído ou não esteja na lista
		
	# Calcula o frame exato do passado que este clone deve seguir
	# Exemplo: 1º clone (index 0) -> frame 30. 2º clone (index 1) -> frame 60.
	var frame_target = player.delay_frames * (my_index + 1)
	
	# Só move se o histórico do player já estiver cheio
	if history.size() > frame_target:
		var target_position = history[frame_target]
		
		# Move suavemente em direção àquela posição
		global_position = target_position


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and touch == false:
		touch = true
		player = body
		body.clones.append(self)
