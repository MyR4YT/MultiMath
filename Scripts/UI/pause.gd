extends Control

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var filtro_velho_oeste: ColorRect = $ColorRect
@onready var botoes_container: VBoxContainer = $Control/VBoxContainer
@onready var bar: Sprite2D = $Control/Parallax2D/Sprite2D
@onready var bar2: Sprite2D = $Control/Parallax2D2/Sprite2D
@onready var pause: Label = $Control/Name
@onready var achivements: TextureRect = $Control/Conquistas

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	botoes_container.modulate.a = 0
	
	# Conectamos o sinal AQUI uma única vez no _ready para evitar o erro!
	animation_player.animation_finished.connect(_on_animation_finished)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Pause"):
		toggle_pause()

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
	
func _on_achivements_pressed() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(achivements, "position:y", 116, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func _on_texture_button_pressed() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(achivements, "position:y", 500, 0.8).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
