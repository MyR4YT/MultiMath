extends Area2D

var player = null
var touch = false
var is_transicionando = false # Nova variável para controlar o efeito inicial

@export var follow_speed: float = 10.0 

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not touch or player == null:
		return
		
	var history = player.position_history
	var my_index = player.clones.find(self)
	
	if my_index == -1:
		return 
		
	var frame_target = player.delay_frames * (my_index + 1)
	
	if history.size() > frame_target:
		var target_position = history[frame_target]
		
		# Mantém o lerp contínuo para o movimento ser sempre suave
		global_position = global_position.lerp(target_position, follow_speed * delta)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and touch == false:
		touch = true
		is_transicionando = true # Ativa o lerp suave temporário
		player = body
		body.clones.append(self)
		# Removemos o bloco repetido de lerp daqui de dentro!
