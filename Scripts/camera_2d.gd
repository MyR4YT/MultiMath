extends Camera2D

enum ModoCamera { ESTATICO, DINAMICO, LIVRE }

@export var modo_atual: ModoCamera = ModoCamera.DINAMICO
@export var velocidade_suave: float = 8.0 # Velocidade da transição no modo Dinâmico e Livre

# INDIQUE AQUI A MARGEM (em pixels): O quanto o player precisa passar da borda para trocar de tela
@export var margem_troca_x: float = 0

# Tamanho da tela do seu jogo (pega direto das configurações do projeto)
@onready var tamanho_tela: Vector2 = Vector2(
	ProjectSettings.get_setting("display/window/size/viewport_width"),
	ProjectSettings.get_setting("display/window/size/viewport_height")
)
@onready var Player = $"../Player"

var posicao_alvo: Vector2
var sala_atual_x: int = 0
var sala_atual_y: int = 0

func _ready() -> void:
	position_smoothing_enabled = false
	
	if Player:
		# Inicializa descobrindo a sala inicial sem aplicar a margem ainda
		sala_atual_x = floor(Player.global_position.x / tamanho_tela.x)
		sala_atual_y = floor(Player.global_position.y / tamanho_tela.y)
		
		posicao_alvo = _calcular_centro_sala(sala_atual_x, sala_atual_y)
		global_position = posicao_alvo

func _process(delta: float) -> void:
	if not Player:
		return 
		
	match modo_atual:
		ModoCamera.ESTATICO:
			pass
			
		ModoCamera.LIVRE:
			posicao_alvo = Player.global_position
			global_position = global_position.lerp(posicao_alvo, velocidade_suave * delta)
			
		ModoCamera.DINAMICO:
			_atualizar_sala_dinamica(Player.global_position)
			posicao_alvo = _calcular_centro_sala(sala_atual_x, sala_atual_y)
			global_position = global_position.lerp(posicao_alvo, velocidade_suave * delta)

# Nova lógica que checa os limites da tela ATUAL considerando a margem
func _atualizar_sala_dinamica(pos_player: Vector2) -> void:
	# Calcula os limites exatos (esquerdo e direito) da sala onde a câmera está parada
	var limite_esquerdo_sala := sala_atual_x * tamanho_tela.x
	var limite_direito_sala := limite_esquerdo_sala + tamanho_tela.x
	
	# Só muda para a sala da DIREITA se o player passar do limite + margem
	if pos_player.x > (limite_direito_sala + margem_troca_x):
		sala_atual_x = floor(pos_player.x / tamanho_tela.x)
	# Só muda para a sala da ESQUERDA se o player voltar além do limite - margem
	elif pos_player.x < (limite_esquerdo_sala - margem_troca_x):
		sala_atual_x = floor(pos_player.x / tamanho_tela.x)
		
	# Mantém a lógica vertical padrão (ou aplique o mesmo padrão se quiser)
	sala_atual_y = floor(pos_player.y / tamanho_tela.y)

# Apenas calcula o centro com base nos índices da sala
func _calcular_centro_sala(sala_x: int, sala_y: int) -> Vector2:
	var centro_x := (sala_x * tamanho_tela.x) + (tamanho_tela.x / 2.0)
	var centro_y := (sala_y * tamanho_tela.y) + (tamanho_tela.y / 2.0)
	return Vector2(centro_x, centro_y)

func mudar_modo(novo_modo: ModoCamera) -> void:
	modo_atual = - novo_modo
