extends Control

@onready var texto_label: RichTextLabel = $RichTextLabel
var tween: Tween

# Lista com todas as mensagens em sequência
var falas: Array[String] = [
	"Olá, viajante! Bem-vindo à [color=yellow]test[/color].",
	"Este é o segundo diálogo da sequência.",
	"Aperte Espaço novamente para encerrar a conversa!"
]
var indice_atual: int = 0

func _ready() -> void:
	iniciar_dialogo(falas)

# Função para iniciar uma lista de diálogos
func iniciar_dialogo(lista_falas: Array[String]) -> void:
	falas = lista_falas
	indice_atual = 0
	if not falas.is_empty():
		mostrar_dialogo(falas[indice_atual])

func mostrar_dialogo(frase: String, velocidade: float = 0.05) -> void:
	# Se já tiver um texto rodando, cancela ele antes de começar o novo
	if tween and tween.is_valid():
		tween.kill()
	
	texto_label.text = frase
	texto_label.visible_ratio = 0.0
	
	# Calcula a duração total baseada na quantidade real de letras visíveis
	var total_letras = texto_label.get_total_character_count()
	var duracao = total_letras * velocidade
	
	tween = create_tween()
	tween.tween_property(texto_label, "visible_ratio", 1.0, duracao)

# Controla o avanço do diálogo com Espaço/Enter (ui_accept)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		# 1. Se o texto ainda está sendo digitado, completa ele na hora
		if tween and tween.is_running():
			tween.kill()
			texto_label.visible_ratio = 1.0
		
		# 2. Se o texto já terminou de aparecer, avança para o próximo
		elif texto_label.visible_ratio >= 1.0:
			indice_atual += 1
			if indice_atual < falas.size():
				mostrar_dialogo(falas[indice_atual])
			else:
				encerrar_dialogo()

func encerrar_dialogo() -> void:
	# Aqui você pode esconder a caixa de diálogo ou liberar o movimento do jogador
	hide()
