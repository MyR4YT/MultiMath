extends Control

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var filtro_velho_oeste: ColorRect = $ColorRect
@onready var botoes_container: VBoxContainer = $Control/VBoxContainer
@onready var bar: Sprite2D = $Control/Parallax2D/Sprite2D
@onready var bar2: Sprite2D = $Control/Parallax2D2/Sprite2D
@onready var pause: Label = $Control/Name

var item = 1

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	botoes_container.modulate.a = 0
	
	# Conectamos o sinal AQUI uma única vez no _ready para evitar o erro!
	animation_player.animation_finished.connect(_on_animation_finished)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		toggle_pause()
		
	if get_tree().paused == true:
		if event.is_action_pressed("ui_down"):
			item += 1
			item = clamp(item, 1, 3)
			
		elif event.is_action_pressed("ui_up"):
			item -= 1
			item = clamp(item, 1, 3)
			
		elif event.is_action_pressed("ui_accept"):
			if item == 1:
				toggle_pause()
			elif item == 2:
				toggle_pause()
				$"../../Node2D3/Void 1".die(true)
			elif item == 3:
				toggle_pause()
				get_tree().change_scene_to_file("res://Cenas/menu.tscn")

func _process(delta: float) -> void:
	if item == 1:
		$Control/VBoxContainer/Button.flat = false
		$Control/VBoxContainer/Reiniciar.flat = true
		$Control/VBoxContainer/Sair.flat = true
	elif item == 2:
		$Control/VBoxContainer/Reiniciar.flat = false
		$Control/VBoxContainer/Sair.flat = true
		$Control/VBoxContainer/Button.flat = true
	elif item == 3:
		$Control/VBoxContainer/Sair.flat = false
		$Control/VBoxContainer/Reiniciar.flat = true
		$Control/VBoxContainer/Button.flat = true
func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	
	if get_tree().paused:
		# PAUSANDO
		show()
		var tween: Tween = create_tween().set_parallel()
		tween.tween_property(bar, "position:x", 600, 0.2)
		tween.tween_property(bar2, "position:x", 750, 0.2)
		animation_player.play("revelar_pausa")
	else:
		# DESPAUSANDO
		# 1. Faz o fade-out dos botões primeiro
		var tween: Tween = create_tween().set_parallel()
		tween.tween_property(botoes_container, "modulate:a", 0.0, 0.1)
		tween.tween_property(pause, "modulate:a", 0.0, 0.1)
		tween.tween_property(bar, "position:x", 840, 0.2)
		tween.tween_property(bar2, "position:x", 990, 0.2)
		# 2. Roda a animação de despausar (NÃO use hide() aqui ainda!)
		animation_player.play("despausar")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "revelar_pausa":
		# Quando termina de abrir, mostra os botões
		var tween: Tween = create_tween().set_parallel()
		tween.tween_property(botoes_container, "modulate:a", 1.0, 0.2)
		tween.tween_property(pause, "modulate:a", 1.0, 0.2)
		
	elif anim_name == "despausar":
		# Só escondemos o menu DEPOIS que a animação de fechar terminar
		hide()

# --- Funções dos Botões ---

func _on_continuar_pressed() -> void:
	toggle_pause()

func _on_sair_pressed() -> void:
	toggle_pause()


func _on_reiniciar_pressed() -> void:
	toggle_pause()
